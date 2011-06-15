$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'xml_schema/ns'
require 'time'

# Slightly modified xml_schema from Redlander project
module XmlSchema

  TYPES = %w(int boolean float dateTime time date string decimal double duration gYearMonth gYear gMonthDay gDay gMonth hexBinary base64Binary anyURI QName NOTATION)


  # Obtain XML Schema datatype (as RDF node) for a Ruby object.
  def self.datatype_of(object)
    #--
    # TODO: decimal, double, duration (Range?), gYearMonth, gYear, gMonthDay, gDay, gMonth, hexBinary, base64Binary, anyURI, QName, NOTATION
    # TODO: language tag?
    #++
    case object.class.name
    when "Fixnum", "Integer"
      NS::XMLSchema['int'].to_s
    when "TrueClass", "FalseClass"
      NS::XMLSchema['boolean'].to_s
    when "Float"
      NS::XMLSchema['float'].to_s
    when "DateTime"
      NS::XMLSchema['dateTime'].to_s
    when "Time"
      NS::XMLSchema['time'].to_s
    when "Date"
      NS::XMLSchema['date'].to_s
    when "String"
      NS::XMLSchema['string'].to_s
    else
      raise RedlandError.new("#{object.class} cannot be coerced into any XMLSchema datatype")
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
