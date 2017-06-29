class Substance < ApplicationRecord

  def substance_profile
    substance_header + cross_tolerance_profile + tolerance_time +
      effects_description + addiction_profile + toxicity_profile
  end

  def dosage_profile
    return no_dosage_information + dose_footer unless substance.has_dosage_info?
    dose_header + insufflation_profile + oral_profile + intravenous_profile + dose_footer
  end

  def interaction_profile
    return no_interaction_information unless substance.has_interaction_info?
  end

  private

  def substance_header
    "#{name} is a #{chemical_class}.\n"
  end

  def cross_tolerance_profile
    return '' unless cross_tolerance
    "It has a cross-tolerance with #{cross_tolerance}\n"
  end

  def tolerance_time
    return '' unless time_to_full_tolerance && time_to_zero_tolerance
    "Full tolerance occurs #{time_to_full_tolerance}. Tolerance diminishes completely in #{time_to_zero_tolerance}\n"
  end

  def effects_description
    return '' unless effects
    "Effects reported include: #{effects}\n"
  end

  def addiction_profile
    return '' unless addiction_potential
    "Its addiction potential is: #{addiction_potential}\n"
  end

  def toxicity_profile
    return '' unless toxicity
    "Its toxicity profile is: #{toxicity}\n"
  end
end
