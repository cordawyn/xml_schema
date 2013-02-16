$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "lib/xml_schema/version"

Gem::Specification.new do |s|
  s.name        = "xml_schema"
  s.version     = XmlSchema::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Slava Kravchenko"]
  s.email       = ["slava.kravchenko@gmail.com"]
  s.homepage    = "https://github.com/cordawyn/xml_schema"
  s.summary     = %q{Helper methods and constants to handle XmlSchema}
  s.description = %q{Helper methods and constants to handle XmlSchema}

  s.rubyforge_project = "xml_schema"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.license       = "The MIT License (MIT)"
  s.extra_rdoc_files = ['README.md']
  s.require_paths = ["lib"]
end
