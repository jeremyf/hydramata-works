require 'feature_helper'
require 'rubydora'

require 'vcr'
require 'webmock'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
end

# Because of Rubydora this is required
def logger
  @logger ||= Logger.new(STDOUT)
end

module Hydramata
  module Work
    class FedoraWrangler
      attr_reader :repo, :entity
      def initialize(collaborators = {})
        @repo = collaborators.fetch(:repository_connection) { default_repository_connection }
        @entity = collaborators.fetch(:entity)
      end

      def call(pid, options = {})
        with_datastreams = options.fetch(:with_datastreams, false)
        object = @repo.find(pid)
        assign_work_type_from(object)
        parse_datastreams(object) if with_datastreams
      end

      private

      def default_repository_connection
        # Please note: these parameters were used in building the VCR cassettes, so please don't change them.
        Rubydora.connect(url: 'http://127.0.0.1:8983/fedora', user: 'fedoraAdmin', password: 'fedoraAdmin')
      end

      def assign_work_type_from(object)
        object.profile['objModels'].each do |model|
          if model =~ /\Ainfo:fedora\/afmodel\:(.*)\Z/
            entity.work_type = Regexp.last_match[1]
            break
          end
        end
      end

      def parse_datastreams(object)
        object.datastreams.each do |_name, datastream|
          parse_datastream_content(datastream)
        end
      end

      def parse_datastream_content(datastream)
        DatastreamParser.call(datastream: datastream, entity: entity) do |property|
          entity.properties << property
        end
      end
    end

    describe 'An in Fedora object is loaded into an in memory work' do
      let(:pid) { 'und:f4752f8687n' }
      let(:work_wrangler) { FedoraWrangler.new(entity: entity) }
      let(:entity) { Entity.new }
      it 'should parse the fedora object to assign the work_type' do
        VCR.use_cassette('fedora-object', record: :none) do
          expect { work_wrangler.call(pid) }.
            to change { entity.work_type }.
            from(nil).
            to('SeniorThesis')
        end
      end

      it 'should parse the fedora object to retrieve the depositor' do
        seed_predicates!
        VCR.use_cassette('fedora-object', record: :none) do
          work_wrangler.call(pid, with_datastreams: true)
          expect { |b| entity.properties.each(&b) }.
          to yield_successive_args(
            Property.new(predicate: 'depositor', value: 'username-1'),
            Property.new(predicate: 'http://purl.org/dc/terms/created', value: Date.new(2014, 6, 2)),
            Property.new(predicate: 'http://purl.org/dc/terms/language', value: 'English'),
            Property.new(predicate: 'http://purl.org/dc/terms/publisher', value: 'University of Notre Dame'),
            Property.new(predicate: 'http://purl.org/dc/terms/title', value: 'Title 1'),
            Property.new(predicate: 'http://purl.org/dc/terms/dateSubmitted', value: Date.new(2014, 6, 2)),
            Property.new(predicate: 'http://purl.org/dc/terms/modified', value: Date.new(2014, 6, 2)),
            Property.new(predicate: 'http://purl.org/dc/terms/rights', value: 'Attribution 3.0 United States'),
            Property.new(predicate: 'http://purl.org/dc/terms/creator', value: 'Creator Name1'),
            Property.new(predicate: 'http://purl.org/dc/terms/description', value: 'Hello World!')
          )
        end
      end

      def seed_predicates!
        Predicates::Storage.delete_all
        Predicates::Storage.create!(identity: 'depositor')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/created', value_parser_name: 'DateParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/language', value_parser_name: 'InterrogationParser' )
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/publisher', value_parser_name: 'InterrogationParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/title', value_parser_name: 'InterrogationParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/dateSubmitted', value_parser_name: 'DateParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/modified', value_parser_name: 'DateParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/rights', value_parser_name: 'InterrogationParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/creator', value_parser_name: 'InterrogationParser')
        Predicates::Storage.create!(identity: 'http://purl.org/dc/terms/description', value_parser_name: 'InterrogationParser')
      end
    end
  end
end
