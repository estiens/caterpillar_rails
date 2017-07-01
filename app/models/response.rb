class Response

  def initialize(intent:, substance:, replies:, interaction_substance: nil)
    @intent = intent
    @substance_name = substance
    @ix_substance_name = interaction_substance
    @substance = nil
    @interaction_substance = nil
    @replies = replies
  end

  def create_reply
    return @replies if @replies.present?
    find_substances
    reply = create_reply_from_intent_and_substance
    [{ type: 'text', content: reply }]
  end

  private

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def message_for_intent_and_substance
    case @intent
    when 'interactions_info'
      report_interactions
    when 'substance_info'
      @substance.substance_profile
    when 'testing_info'
      @substance.testing_profile
    when 'dosage_info'
      @substance.dose_profile
    when 'effects_info'
      @substance.effects_profile
    when 'duration_info'
      @substance.duration_profile
    else
      Rails.logger.info "Intent should have been caught: #{@intent}"
      "Sorry, I didn't know what you meant"
    end
  end
  # rubocop:enable

  # think about starting to move these out of Response model
  def report_interactions
    if @substance && !@interaction_substance
      return "Sorry, I know you want to know about mixing something with #{@substance.name}, but I'm not sure what"
    end
    interaction = Interaction.find_any_interaction(@substance, @interaction_substance)
    interaction = fetch_interactions_for(@substance.name, @interaction_substance.name) unless interaction
    return interaction.message if interaction
    "Sorry I couldn't find interaction info"
  end

  def fetch_interactions_for(drug1, drug2)
    interactions = TripSit::SubstanceRequester.interaction_lookup(drug1: drug1, drug2: drug2)
    status = interactions[:status]
    note = interactions[:note]
    return nil unless status
    Interaction.create(substance_a: @substance, substance_b: @interaction_substance,
                       status: status, notes: note)
  end

  def find_substances
    @substance = Drug.find_with_aliases(@substance_name)
    @interaction_substance = Drug.find_with_aliases(@ix_substance_name)
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
