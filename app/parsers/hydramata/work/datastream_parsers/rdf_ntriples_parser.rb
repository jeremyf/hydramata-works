require 'rdf'
module Hydramata
  module Work
    module DatastreamParsers
      class RdfNtriplesParser
        def self.call(data, &block)
          new.call(data, &block)
        end

        def initialize
          @graph = default_graph
          @reader = default_reader
          @pattern = default_pattern
        end

        def call(data, &block)
          query_graph_with(data, &block)
        end

        private

        def query_graph_with(data, &block)
          graph << reader.new(data)
          graph.query(pattern).each_statement do |statement|
            yield(predicate: statement.predicate.to_s, value: statement.object.to_s)
          end
        end

        attr_reader :graph, :reader, :pattern
        private :graph, :reader, :pattern

        def default_graph
          RDF::Graph.new
        end

        def default_reader
          RDF::Reader.for(:ntriples)
        end

        def default_pattern
          RDF::Query::Pattern.from([:s, :p, :o])
        end
      end
    end
  end
end
