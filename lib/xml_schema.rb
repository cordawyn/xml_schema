require 'time'
require 'xml_schema/ns'
require 'ext/string'
require 'ext/localized_string'

module XmlSchema
  TYPES = %w(integer boolean float dateTime time date string decimal double duration gYearMonth gYear gMonthDay gDay gMonth hexBinary base64Binary anyURI QName NOTATION)

  # Obtain XML Schema datatype URI for a Ruby object.
  def self.datatype_of(object)
    #--
    # TODO: decimal, double, duration (Range?), gYearMonth, gYear, gMonthDay, gDay, gMonth, hexBinary, base64Binary, anyURI, QName, NOTATION
    #++
    case object.class.name
    when "Fixnum", "Integer"
      NS::XMLSchema['integer']
    when "TrueClass", "FalseClass"
      NS::XMLSchema['boolean']
    when "Float"
      NS::XMLSchema['float']
    when "DateTime"
      NS::XMLSchema['dateTime']
    when "Time"
      NS::XMLSchema['time']
    when "Date"
      NS::XMLSchema['date']
    when "String", "LocalizedString"
      NS::XMLSchema['string']
    else
      raise "#{object.class} cannot be coerced into any XMLSchema datatype"
    end
  end

  # Instantiate a Ruby object from a literal string and datatype URI.
  # If +datatype_uri+ is not specified,
  # +literal+ is interpreted as RDF typed literal (with datatype postfix).
  def self.instantiate(literal, datatype_uri = nil)
    # NOTE: removing language tag (e.g. "@en")
    lang_regexp = /@(\w+{2})$/
    lang = nil
    if literal =~ lang_regexp
      lang = $1
      # make a local copy of literal, with removed lang tag
      literal = literal.sub(lang_regexp, "")
    end
    
    full_literal = datatype_uri ? literal + "^^<#{datatype_uri}>" : literal
    literal_value, literal_type = full_literal.split('^^')
    datatype =
      if literal_type
        ns, l_type = literal_type.delete("<>").split('#')
        # TODO: somehow use a better comparison of URIs which ignores "/" at the end?
        if URI(ns.sub(/\/*$/, "/")) == NS::XMLSchema.uri && TYPES.include?(l_type)
          l_type
        else
          raise "Incompatible datatype URI! (#{ns})"
        end
      else
        'string'
      end

    # clean-up literal_value
    literal_value.sub!(/^["']/, '')
    literal_value.sub!(/["']$/, '')

    case datatype
    when 'integer'
      literal_value.to_i
    when 'boolean'
      %w(1 true).include?(literal_value)
    when 'dateTime'
      DateTime.parse(literal_value)
    when 'date'
      Date.parse(literal_value)
    when 'time'
      Time.parse(literal_value)
    when 'float'
      literal_value.to_f
    else
      if lang
        LocalizedString.new(literal_value, lang.to_sym)
      else
        # FIXME: fallback for unknown datatypes and 'string'
        literal_value
      end
    end
  end
end
