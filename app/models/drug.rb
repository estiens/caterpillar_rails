class Drug < ApplicationRecord

  def self.find_with_aliases(name)
    name = name&.downcase
    drug = find_by(name: name)
    return drug if drug
    find_by('? = ANY (aliases)', name)
  end

  def substance_name
    name.upcase == name ? name : name.humanize
  end

  def substance_profile
    profile = substance_name
    profile += alias_string.to_s
    profile += ': '
    profile += drug_summary.gsub('"', "'")
    profile += " #{addiction_profile}"
    profile += " Warning note! Avoid #{avoid_info}" if avoid_info
    profile.gsub('..', '.').strip
  end

  def testing_profile
    return "Sorry, we do not have test kit info for #{substance_name}" if tests.empty?
    "We have the following reagent test results for #{substance_name}. #{test_results}"
  end

  def dose_profile
    return "Sorry, we don't have any reported dosing information for #{substance_name}." unless dose_summary
    summary = "We have the following dose information for #{substance_name}: "
    summary += dose_summary
    summary += " Warning note! Avoid #{avoid_info}" if avoid_info
    summary.gsub('..', '.')
  end

  def effects_profile
    return "Sorry, we don't have any reported effects for #{substance_name}" unless effects_string
    profile = "Effects reported for #{substance_name} are: "
    profile += effects_string
    profile.gsub('..', '.')
  end

  def duration_profile
    unless onset_summary || duration_summary || after_effects
      return "Sorry, we don't know anything about the duration of effects for #{substance_name}"
    end
    duration_of_effects_string.gsub('..', '.')
  end

  def safety_profile
    safety_profile = 'No substance is completely safe (not even water). We want you to make informed choices. '
    safety_profile += " Warning note for #{substance_name}! Avoid #{avoid_info} " if avoid_info
    safety_profile += toxicity_profile
    safety_profile += "If you want more information, ask for 'info about #{substance_name}'. "
    safety_profile.gsub('..', '.')
  end

  def tolerance_profile
    unless cross_tolerance_profile || tolerance_time
      return "Sorry we don't know anything about tolerance for #{substance_name}."
    end
    "Here's what we know about #{substance_name}. #{cross_tolerance_profile}#{tolerance_time}"
  end

  def toxicity_profile
    if toxicity_info
      "We have the following toxicity information for #{substance_name}: #{toxicity_info}. "
    else
      "We currently have no toxicity information about #{substance_name}. "
    end
  end

  private

  def duration_of_effects_string
    profile = "This is the duration information we have for #{substance_name}. "
    profile += "Reported onset time is #{onset_summary}. " if onset_summary
    profile += "Duration of effects is #{duration_summary}. " if duration_summary
    profile += "After effects can be #{after_effects}." if after_effects
    profile
  end

  def effects_string
    return nil unless effects
    effects.map(&:downcase)&.to_sentence
  end

  def tests
    [marquis_test, mandelin_test, mecke_test, liebermann_test, froehde_test, gallic_acid_test, ehrlic_test].compact
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def test_results
    test_result_string = ''
    test_result_string += "Marquis test: #{marquis_test}. " if marquis_test
    test_result_string += "Mandelin test: #{mandelin_test}. " if mandelin_test
    test_result_string += "Mecke test: #{mecke_test}. " if mecke_test
    test_result_string += "Liebermann Test: #{liebermann_test}. " if liebermann_test
    test_result_string += "Froehde Test: #{froehde_test}. " if froehde_test
    test_result_string += "Gallic Acid Test: #{gallic_acid_test}. " if gallic_acid_test
    test_result_string += "Ehrlic Test: #{ehrlic_test}." if ehrlic_test
    test_result_string
  end
  # rubocop:enable

  def alias_string
    return nil if aliases.blank?
    " (also known as #{aliases.map(&:downcase)&.to_sentence})"
  end

  def avoid_info
    return nil unless avoid
    avoid[0] = avoid[0].downcase
    avoid
  end

  def addiction_profile
    return '' unless addiction_potential
    "It is considered #{addiction_potential}."
  end

  def cross_tolerance_profile
    return nil unless cross_tolerance
    "It has a cross-tolerance with #{cross_tolerance}. "
  end

  def tolerance_time
    return nil unless time_to_full_tolerance && time_to_zero_tolerance
    "Full tolerance occurs #{time_to_full_tolerance}. Tolerance diminishes completely in #{time_to_zero_tolerance}. "
  end
end
