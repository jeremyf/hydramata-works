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
            entity.work_type = $1
            break
          end
        end
      end

      def parse_datastreams(object)
        object.datastreams.each do |name, datastream|
          parse_datastream_content(name, datastream.content)
        end
      end

      def parse_datastream_content(name, content)
        DatastreamParser.call(content: content, datastream_name: name, entity: entity) do |property|
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
        VCR.use_cassette('fedora-object', record: :none) do
          expect { work_wrangler.call(pid, with_datastreams: true) }.
            to change { entity.properties[:depositor].values }.
            from([]).
            to(['username-1'])
        end
      end
    end
  end
end
