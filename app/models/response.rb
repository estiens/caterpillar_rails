class Response

  def initialize(intent:, substance:)
    @intent = intent
    @substance = substance
  end

  def message
    @substance.substance_profile
  end

end
