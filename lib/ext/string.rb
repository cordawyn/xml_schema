class String
  # Helper method to set the language of the string.
  #
  # @example
  #   "Bonjour".with_lang(:fr).sub(/.$/, "s")
  #
  # @return [self]
  def with_lang(lng)
    LocalizedString.new(self, lng)
  end
end
