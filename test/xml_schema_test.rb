require "test_helper"

class XmlSchemaTest < Test::Unit::TestCase
  def test_should_instantiate_an_integer
    value = XmlSchema.instantiate "55^^<http://www.w3.org/2001/XMLSchema#int>"
    assert_equal 55, value
  end

  def test_should_instantiate_a_boolean_true
    value = XmlSchema.instantiate "true^^<http://www.w3.org/2001/XMLSchema#boolean>"
    assert_equal true, value
  end

  def test_should_instantiate_a_boolean_false
    value = XmlSchema.instantiate "false^^<http://www.w3.org/2001/XMLSchema#boolean>"
    assert_equal false, value
  end

  def test_should_instantiate_a_float
    value = XmlSchema.instantiate "7.62^^<http://www.w3.org/2001/XMLSchema#float>"
    assert_equal 7.62, value
  end

  def test_should_instantiate_a_datetime
    value = XmlSchema.instantiate "2012-06-13T09:30:22^^<http://www.w3.org/2001/XMLSchema#dateTime>"
    assert_equal DateTime.parse("2012-06-13T09:30:22"), value
  end

  def test_should_instantiate_a_time
    value = XmlSchema.instantiate "2012-06-13T09:30:22^^<http://www.w3.org/2001/XMLSchema#time>"
    assert_equal Time.parse("2012-06-13T09:30:22"), value
  end

  def test_should_instantiate_a_date
    value = XmlSchema.instantiate "2012-06-13^^<http://www.w3.org/2001/XMLSchema#date>"
    assert_equal Date.parse("2012-06-13"), value
  end

  def test_should_instantiate_a_string
    value = XmlSchema.instantiate "hello^^<http://www.w3.org/2001/XMLSchema#string>"
    assert_equal "hello", value
  end

  def test_should_instantiate_a_string_by_default
    value = XmlSchema.instantiate "ahoy!"
    assert_equal "ahoy!", value
  end

  def test_should_raise_exception_on_unknown_datatype
    assert_raise RuntimeError do
      XmlSchema.instantiate "???^^<http://www.w3.org/2001/XMLSchema#unknown>"
    end
  end

  def test_should_return_datatype_for_integer
    assert_equal "http://www.w3.org/2001/XMLSchema#int", XmlSchema.datatype_of(42)
  end

  def test_should_return_datatype_for_boolean
    assert_equal "http://www.w3.org/2001/XMLSchema#boolean", XmlSchema.datatype_of(true)
  end

  def test_should_return_datatype_for_float
    assert_equal "http://www.w3.org/2001/XMLSchema#float", XmlSchema.datatype_of(11.11)
  end

  def test_should_return_datatype_for_datetime
    assert_equal "http://www.w3.org/2001/XMLSchema#dateTime", XmlSchema.datatype_of(DateTime.new)
  end

  def test_should_return_datatype_for_time
    assert_equal "http://www.w3.org/2001/XMLSchema#time", XmlSchema.datatype_of(Time.now)
  end

  def test_should_return_datatype_for_date
    assert_equal "http://www.w3.org/2001/XMLSchema#date", XmlSchema.datatype_of(Date.today)
  end

  def test_should_return_datatype_for_string
    assert_equal "http://www.w3.org/2001/XMLSchema#string", XmlSchema.datatype_of("test")
  end

  def test_should_raise_exception_on_unknown_class
    assert_raise RuntimeError do
      XmlSchema.datatype_of(Object.new)
    end
  end
end
