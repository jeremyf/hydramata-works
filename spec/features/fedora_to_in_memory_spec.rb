require 'spec_slow_helper'

module Hydramata
  module Works

    describe 'A Fedora object loaded into an in memory work' do
      before(:each) do
        load File.expand_path('../../support/feature_seeds.rb', __FILE__)
      end
      let(:pid) { 'und:f4752f8687n' }
      let(:work_wrangler) { FromPersistence::FedoraWrangler.new(work: work) }
      let(:work) { Work.new }

      it 'parses the Fedora object, assigning predicates and values to the work' do
        seed_predicates! do
          work_wrangler.call(pid, with_datastreams: true)
          expect { |b| work.properties.each(&b) }.
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

      private
      def seed_predicates!(vcr_cassette = 'fedora-object')
        VCR.use_cassette(vcr_cassette, record: :none) do
          yield
        end
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
