# LocalizedString is just a common String with "lang" attribute,
# which specifies the language of the text stored in the string.
#
# @example
#   str = LocalizedString.new("Hello", :en)
#   "Bonjour".with_lang(:fr) == str # => false
class LocalizedString < String
  attr_reader :lang

  def initialize(str, lng = nil)
    @lang = lng
    super str
  end

  # In addition to comparing string values
  # LocalizedString also compares "lang" values.
  # When compared to a common String,
  # "lang" value is ignored.
  #
  # @param [String, LocalizedString] str
  # @return [Boolean]
  def eql?(str)
    if str.respond_to?(:lang)
      self.lang == str.lang && super
    else
      super
    end
  end
  alias :== :eql?
end
