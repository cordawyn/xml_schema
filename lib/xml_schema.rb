require 'time'
require 'xml_schema/ns'

module XmlSchema
  TYPES = %w(int boolean float dateTime time date string decimal double duration gYearMonth gYear gMonthDay gDay gMonth hexBinary base64Binary anyURI QName NOTATION)


  # Obtain XML Schema datatype URI for a Ruby object.
  def self.datatype_of(object)
    #--
    # TODO: decimal, double, duration (Range?), gYearMonth, gYear, gMonthDay, gDay, gMonth, hexBinary, base64Binary, anyURI, QName, NOTATION
    # TODO: language tag?
    #++
    case object.class.name
    when "Fixnum", "Integer"
      NS::XMLSchema['int']
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
    when "String"
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
    full_literal = datatype_uri ? literal.sub(/@\w+$/, '') + "^^<#{datatype_uri}>" : literal.sub(/@\w+$/, '')
    literal_value, literal_type = full_literal.split('^^')
    datatype = if literal_type
      ns, l_type = literal_type.delete("<>").split('#')
      if ns == NS::XMLSchema.uri && TYPES.include?(l_type)
        l_type
      else
        raise "Incompatible datatype URI! (#{ns})"
      end
    else
      'string'
    end

    # clean-up the literal_value
    literal_value.sub!(/^["']/, '')
    literal_value.sub!(/["']$/, '')

    case datatype
    when 'int'
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
      # FIXME: fallback for unknown datatypes and 'string'
      literal_value
    end
  end
end
