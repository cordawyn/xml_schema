require "test_helper"

class LocalizedStringTest < Test::Unit::TestCase
  def test_initialized_with_no_lang
    assert_equal nil, LocalizedString.new("hello").lang
  end

  def test_initialized_with_given_locale
    assert_equal :de, LocalizedString.new("tag", :de).lang
  end

  def test_compared_to_another_localized_string
    assert_equal LocalizedString.new("hello"), LocalizedString.new("hello")
  end

  def test_does_not_compare_to_localized_string_in_another_language
    assert_not_equal LocalizedString.new("hello"), LocalizedString.new("hello", :ja)
  end

  def test_compared_to_string
    assert_equal LocalizedString.new("hello"), "hello"
  end

  def test_initialized_via_string_with_lang
    assert "hello".with_lang(:en).is_a?(LocalizedString)
  end
end
