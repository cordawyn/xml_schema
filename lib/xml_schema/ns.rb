require 'uri'

module NS
  # Add a resource namespace
  #
  # @param [String] name name of the module
  # @param [String] uri URI of the resource
  def self.add(name, uri)
    ns_module = self.const_set(name, Module.new)
    ns_module.module_eval <<-HERE
      def self.uri
        URI(\"#{uri.sub(/\/?$/, '/')}\")
      end

      def self.to_s
        \"#{uri}\"
      end

      def self.[](value)
        URI(\"\#{self}#\#{value}\")
      end
HERE
  end
end

NS.add 'XMLSchema', 'http://www.w3.org/2001/XMLSchema'
NS.add 'OWL', 'http://www.w3.org/2002/07/owl'
NS.add 'RDF', 'http://www.w3.org/1999/02/22-rdf-syntax-ns'
NS.add 'RDFS', 'http://www.w3.org/2000/01/rdf-schema'
NS.add 'FOAF', 'http://xmlns.com/foaf/0.1'
NS.add 'DC', 'http://purl.org/dc'
