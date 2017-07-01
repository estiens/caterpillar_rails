class Drug < ApplicationRecord

  def self.find_with_aliases(name)
    drug = find_by(name: name)
    return drug if drug
    find_by('? = ANY (aliases)', name)
  end

  def substance_profile
    profile = substance_name
    profile += " (also known as #{alias_string})" if aliases.present?
    profile += ': '
    profile += drug_summary.gsub('"', "'")
    profile += " Warning note! Avoid #{avoid_info}" if avoid_info
    profile.gsub('..', '.')
  end

  def testing_profile
    tests ? tests : "Sorry, we do not have test kit info for #{substance_name}"
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
    return nil unless marquis || test_kits
    testing_profile = "Test info for #{substance_name}. "
    testing_profile += "Marquis test should be #{marquis}. " if marquis
    testing_profile += "All test kits: #{test_kits}" if test_kits
    testing_profile.gsub('..', '.')
  end

  def substance_name
    name.upcase == name ? name : name.humanize
  end

  def alias_string
    aliases.map(&:downcase)&.to_sentence
  end

  def avoid_info
    return nil unless avoid
    avoid[0] = avoid[0].downcase
    avoid
  end
end
