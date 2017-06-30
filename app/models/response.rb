class Response

  def initialize(intent:, substance_name:, replies:)
    @intent = intent
    @substance_name = substance_name
    @substance = nil
    @replies = replies
  end

  def create_reply
    return @replies if @replies.present?
    find_substance
    reply = create_reply_from_intent_and_substance
    [{ type: 'text', content: reply }]
  end

  private

  def message_for_intent_and_substance # rubocop:disable Metrics/MethodLength
    case @intent
    when 'substance_info'
      @substance.substance_profile
    when 'testing_info'
      @substance.testing_profile
    when 'dosage_info'
      @substance.dose_profile
    when 'effect_info'
      @substance.effects_profile
    when 'duration_info'
      @substance.duration_profile
    else
      logger.info "Intent should have been caught: #{intent}"
      "Sorry, I didn't know what you meant"
    end
  end

  def find_substance
    @substance = Drug.find_by(name: @substance_name)
    @substance ||= Drug.find_by('? = ANY (aliases)', @substance_name)
  end

  def create_reply_from_intent_and_substance
    if !@intent || @intent == 'unknown'
      could_not_determine_intent
    elsif !@substance
      could_not_determine_substance
    else
      message_for_intent_and_substance
    end
  end

  def could_not_determine_substance
    message = "Sorry, but I couldn't determine what substance you were inquiring about, "
    message += "but I think you wanted to know about #{@intent.humanize.downcase.with_indefinite_article}."
    message
  end

  def could_not_determine_intent
    if @substance
      message = "I could tell you want info about #{@substance.name}. "
      message += "I couldn't tell what kind of info. Try info, dosage, effects, or testing"
    else
      message = complete_unknown_message
    end
    message
  end

  def complete_unknown_message
    message = "Sorry, but I couldn't tell what you wanted."
    message += "Right now, you can try 'Tell me about [substance]'"
    message
  end
end
