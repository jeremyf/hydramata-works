module Hydramata
  module Works
    module DatastreamParsers
      # Responsible for parsing an ntriples encoded datastructure.
      class RdfNtriplesParser
        def self.match?(options = {})
          datastream = options[:datastream]
          return false unless datastream
          if datastream.mimeType == 'text/plain' &&
            datastream.content =~ /\A\<info:fedora/
            self
          else
            false
          end
        end

        def self.call(data, collaborators = {}, &block)
          new(collaborators).call(data, &block)
        end

        def initialize(collaborators = {})
          @graph = collaborators.fetch(:graph) { default_graph }
          @reader = collaborators.fetch(:reader) { default_reader }
          @pattern = collaborators.fetch(:pattern) { default_pattern }
        end

        def call(data, &block)
          query_graph_with(data, &block)
        end

        private

        def query_graph_with(data)
          graph << reader.new(data)
          graph.query(pattern).each_statement do |statement|
            yield(predicate: statement.predicate.to_s, value: statement.object)
          end
        end

        attr_reader :graph, :reader, :pattern
        private :graph, :reader, :pattern

        def default_graph
          require 'rdf'
          RDF::Graph.new
        end

        def default_reader
          require 'rdf'
          RDF::Reader.for(:ntriples)
        end

        def default_pattern
          require 'rdf'
          RDF::Query::Pattern.from([:s, :p, :o])
        end
      end
    end
  end
end
