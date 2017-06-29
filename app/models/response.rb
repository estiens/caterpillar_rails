class Response

  def initialize(intent:, substance:)
    @intent = intent
    @substance = substance
  end

  # rubocop:disable Metrics/MethodLength
  def message
    case @intent
    when 'substance_info'
      @substance.substance_profile
    when 'testing_info'
      @substance.testing_profile
    when 'dosage_info'
      @substance.dosage_profile
    when 'effect_info'
      @substance.effects_profile
    when 'duration_info'
      @substance.duration_profile
    else
      logger.info "Intent should have been caught: #{intent}"
      "Sorry, I didn't know what you meant"
    end
  end
  # rubocop:enable Metrics/MethodLength
end
