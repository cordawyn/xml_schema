require 'uri'

module NS

  ALL = {
    'XMLSchema' => 'http://www.w3.org/2001/XMLSchema',
    'OWL' => 'http://www.w3.org/2002/07/owl',
    'RDF' => 'http://www.w3.org/1999/02/22-rdf-syntax-ns',
    'RDFS' => 'http://www.w3.org/2000/01/rdf-schema'
  }

  ALL.each do |name, url|
    ns_module = self.const_set(name, Module.new)
    ns_module.module_eval <<-HERE
      def self.uri
        \"#{url}\"
      end

      def self.to_s
        \"\#{uri}#\"
      end

      def self.[](value)
        URI.parse(\"\#{self}\#{value}\")
      end
HERE
  end

end
