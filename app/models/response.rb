class Response

  def initialize(intent:, substance:)
    @intent = intent
    @substance = substance
  end

  def message
    if @substance
      @substance.substance_profile
    else
      refer_out_no_substance
    end
  end

  def refer_out_no_substance
    "I'm sorry, but I don't have any information about that'"
  end
end
