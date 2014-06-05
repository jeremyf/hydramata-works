require 'fast_helper'
require 'hydramata/work/datastream_parsers/rdf_ntriples_parser'
require 'hydramata/work/linters'
require 'rdf'

module Hydramata
  module Work
    module DatastreamParsers
      describe RdfNtriplesParser do
        it_behaves_like 'a datastream parser'

        let(:rdf_subject) { 'info:fedora/und:f4752f8687n' }
        let(:rdf_predicate) { 'http://purl.org/dc/terms/dateSubmitted' }

        subject { described_class }

        context 'with single value encountered' do
          let(:rdf_object) { "\"#{rdf_object_value}\"^^<http://www.w3.org/2001/XMLSchema#date>" }
          let(:rdf_object_value) { '2014-06-02Z' }
          let(:data) { "<#{rdf_subject}> <#{rdf_predicate}> #{rdf_object} ." }
          it 'should yield each encountered property' do
            expect { |b| subject.call(data, &b) }.to yield_with_args(predicate: rdf_predicate, value: instance_of(RDF::Literal::Date))
          end
        end

        context 'with multiple values encountered' do
          let(:rdf_object_1) { "\"#{rdf_object_value_1}\"^^<http://www.w3.org/2001/XMLSchema#date>" }
          let(:rdf_object_2) { "\"#{rdf_object_value_2}\"^^<http://www.w3.org/2001/XMLSchema#date>" }
          let(:rdf_object_value_1) { '2014-06-02Z' }
          let(:rdf_object_value_2) { '2013-05-03Z' }
          let(:data) do
            [
              "<#{rdf_subject}> <#{rdf_predicate}> #{rdf_object_1} .",
              "<#{rdf_subject}> <#{rdf_predicate}> #{rdf_object_2} ."
            ].join("\n")
          end

          it 'should yield each encountered property' do
            expect { |b| subject.call(data, &b) }.
            to yield_successive_args(
              { predicate: rdf_predicate, value: instance_of(RDF::Literal::Date) },
              { predicate: rdf_predicate, value: instance_of(RDF::Literal::Date) }
            )
          end
        end
      end
    end
  end
end
