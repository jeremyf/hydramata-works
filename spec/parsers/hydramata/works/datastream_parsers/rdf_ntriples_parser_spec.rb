require 'spec_fast_helper'
require 'hydramata/works/datastream_parsers/rdf_ntriples_parser'
require 'hydramata/works/linters/implement_datastream_parser_interface_matcher'
require 'rdf'

module Hydramata
  module Works
    module DatastreamParsers
      describe RdfNtriplesParser do

        let(:rdf_subject) { 'info:fedora/und:f4752f8687n' }
        let(:rdf_predicate) { 'http://purl.org/dc/terms/dateSubmitted' }
        let(:rdf_object) { "\"#{rdf_object_value}\"^^<http://www.w3.org/2001/XMLSchema#date>" }
        let(:rdf_object_value) { '2014-06-02Z' }
        let(:data) { "<#{rdf_subject}> <#{rdf_predicate}> #{rdf_object} ." }

        subject { described_class }

        it { should implement_datastream_parser_interface }

        context '.match?' do
          let(:ntriples_datastream) { double(content: data, mimeType: 'text/plain') }
          let(:not_ntriples_datastream) { double(content: '', mimeType: 'application/xml') }
          it 'should not match when no datastream is provided' do
            expect(described_class.match?).to be_falsey
          end

          it 'should match when an RDF ntriples datastream is provided' do
            expect(described_class.match?(datastream: ntriples_datastream)).to eq(described_class)
          end

          it 'should not match when the data stream does not appear to be RDF ntriples' do
            expect(described_class.match?(datastream: not_ntriples_datastream)).to be_falsey
          end
        end

        context 'with single value encountered' do
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
