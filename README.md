# XML Schema

`XmlSchema` gem is a simple convertor utility for XML Schema (literal) datatypes to/from native Ruby objects.


# Usage

    $ require "xml_schema"

    $ XmlSchema.datatype_of(true)  # => #<URI::HTTP:0x00000000dcff78 URL:http://www.w3.org/2001/XMLSchema#boolean>
    $ XmlSchema.datatype_of(Time.now)  # => #<URI::HTTP:0x00000000dcff78 URL:http://www.w3.org/2001/XMLSchema#time>

    $ XmlSchema.instantiate("55^^<http://www.w3.org/2001/XMLSchema#int>")  # => 55

XmlSchema also provides means to access and work with frequently used namespaces:

    $ NS::OWL.uri  # => #<URI::HTTP:0x00000000dcff78 URL:http://www.w3.org/2002/07/owl>
    $ NS::RDFS["hello"]  # => #<URI::HTTP:0x00000000dcff78 URL:http://www.w3.org/2000/01/rdf-schema#hello>

That's pretty much all there is to it.


# Extras

This gem introduces LocalizedString to handle localized string literals.

    $ s = LocalizedString.new("hello", :en)
    $ s.lang  # => :en
    $ XMLSchema.instantiate("hello@en")  # => <LocalizedString: "hello">

When compared to a String object, language is ignored and only the string content is compared.
When compared to another LocalizedString, languages are also compared.

You can also initialize a LocalizedString as follows:

    $ "bonjour".with_lang(:fr)  # => "bonjour"


# Authors

- [Slava Kravchenko](https://github.com/cordawyn)
