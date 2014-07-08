require 'spec_slow_helper'
require 'hydramata/works/fedora_wrangler'

module Hydramata
  module Works

    describe 'An in Fedora object is loaded into an in memory work' do
      let(:pid) { 'und:f4752f8687n' }
      let(:work_wrangler) { FedoraWrangler.new(entity: entity) }
      let(:entity) { Entity.new }

      it 'should parse the Fedora object and assign the predicates' do
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
            Property.new(predicate: 'http://purl.org/dc/terms/dateSubmitted', value: Date.new(2014, 6, 4)),
            Property.new(predicate: 'http://purl.org/dc/terms/modified', value: Date.new(2014, 6, 3)),
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

require 'vcr'
require 'webmock'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
end

# Because of Rubydora this is required
def logger
  @logger ||= Logger.new("/dev/null")
end
