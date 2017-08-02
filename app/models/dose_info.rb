class DoseInfo < ApplicationRecord
  belongs_to :drug

  def info_string
    info_strings = [insufflation_dose_string, oral_dose_string, smoked_dose_string,
                    intravenous_dose_string, sublingual_dose_string].compact
    return nil if info_strings.empty?
    string = "We have the following dose information for #{drug.name}. "
    string += info_strings.join('. ') + '.'
    string
  end

  def insufflation_dose_string
    return nil if insufflation_doses.compact.empty?
    "Insufflation (snorting) doses: #{insufflation_doses.compact.join(' | ')}"
  end

  def oral_dose_string
    return nil if oral_doses.compact.empty?
    "Oral doses: #{oral_doses.compact.join(' | ')}"
  end

  def intravenous_dose_string
    return nil if intravenous_doses.compact.empty?
    "Intravenous doses: #{intravenous_doses.compact.join(' | ')}"
  end

  def smoked_dose_string
    return nil if smoked_doses.compact.empty?
    "Smoking doses: #{smoked_doses.compact.join(' | ')}"
  end

  def sublingual_dose_string
    return nil if sublingual_doses.compact.empty?
    "Sublingual doses: #{sublingual_doses.compact.join(' | ')}"
  end

  private

  def insufflation_doses
    [threshold_insufflation_dose_string, light_insufflation_dose_string, common_insufflation_dose_string,
     strong_insufflation_dose_string, heavy_insufflation_dose_string]
  end

  def oral_doses
    [threshold_oral_dose_string, light_oral_dose_string, common_oral_dose_string,
     strong_oral_dose_string, heavy_oral_dose_string]
  end

  def intravenous_doses
    [threshold_intravenous_dose_string, light_intravenous_dose_string, common_intravenous_dose_string,
     strong_intravenous_dose_string, heavy_intravenous_dose_string]
  end

  def smoked_doses
    [threshold_smoked_dose_string, light_smoked_dose_string, common_smoked_dose_string,
     strong_smoked_dose_string, heavy_smoked_dose_string]
  end

  def sublingual_doses
    [threshold_sublingual_dose_string, light_sublingual_dose_string, common_sublingual_dose_string,
     strong_sublingual_dose_string, heavy_sublingual_dose_string]
  end

  def threshold_insufflation_dose_string
    return nil unless insufflated_threshold_dose
    "Threshold dose: #{insufflated_threshold_dose}#{insufflated_dose_units}"
  end

  def light_insufflation_dose_string
    return nil unless insufflated_min_light_dose || insufflated_max_light_dose
    "Light dose: #{insufflated_min_light_dose}#{insufflated_dose_units} -"\
    " #{insufflated_max_light_dose}#{insufflated_dose_units}"
  end

  def common_insufflation_dose_string
    return nil unless insufflated_min_common_dose || insufflated_max_common_dose
    "Common dose: #{insufflated_min_common_dose}#{insufflated_dose_units} -"\
    " #{insufflated_max_common_dose}#{insufflated_dose_units}"
  end

  def strong_insufflation_dose_string
    return nil unless insufflated_min_strong_dose || insufflated_max_strong_dose
    "Strong dose: #{insufflated_min_strong_dose}#{insufflated_dose_units} -"\
    " #{insufflated_max_strong_dose}#{insufflated_dose_units}"
  end

  def heavy_insufflation_dose_string
    return nil unless insufflated_heavy_dose
    "Heavy dose: #{insufflated_heavy_dose}#{insufflated_dose_units}"
  end

  def threshold_oral_dose_string
    return nil unless oral_threshold_dose
    "Threshold dose: #{oral_threshold_dose}#{oral_dose_units}"
  end

  def light_oral_dose_string
    return nil unless oral_min_light_dose || oral_max_light_dose
    "Light dose: #{oral_min_light_dose}#{oral_dose_units} -"\
    " #{oral_max_light_dose}#{oral_dose_units}"
  end

  def common_oral_dose_string
    return nil unless oral_min_common_dose || oral_max_common_dose
    "Common dose: #{oral_min_common_dose}#{oral_dose_units} -"\
    " #{oral_max_common_dose}#{oral_dose_units}"
  end

  def strong_oral_dose_string
    return nil unless oral_min_strong_dose || oral_max_strong_dose
    "Strong dose: #{oral_min_strong_dose}#{oral_dose_units} -"\
    " #{oral_max_strong_dose}#{oral_dose_units}"
  end

  def heavy_oral_dose_string
    return nil unless oral_heavy_dose
    "Heavy dose: #{oral_heavy_dose}#{oral_dose_units}"
  end

  def threshold_smoked_dose_string
    return nil unless smoked_threshold_dose
    "Threshold dose: #{smoked_threshold_dose}#{smoked_dose_units}"
  end

  def light_smoked_dose_string
    return nil unless smoked_min_light_dose || smoked_max_light_dose
    "Light dose: #{smoked_min_light_dose}#{smoked_dose_units} -"\
    " #{smoked_max_light_dose}#{smoked_dose_units}"
  end

  def common_smoked_dose_string
    return nil unless smoked_min_common_dose || smoked_max_common_dose
    "Common dose: #{smoked_min_common_dose}#{smoked_dose_units} -"\
    " #{smoked_max_common_dose}#{smoked_dose_units}"
  end

  def strong_smoked_dose_string
    return nil unless smoked_min_strong_dose || smoked_max_strong_dose
    "Strong dose: #{smoked_min_strong_dose}#{smoked_dose_units} -"\
    " #{smoked_max_strong_dose}#{smoked_dose_units}"
  end

  def heavy_smoked_dose_string
    return nil unless smoked_heavy_dose
    "Heavy dose: #{smoked_heavy_dose}#{smoked_dose_units}"
  end

  def threshold_sublingual_dose_string
    return nil unless sublingual_threshold_dose
    "Threshold dose: #{sublingual_threshold_dose}#{sublingual_dose_units}"
  end

  def light_sublingual_dose_string
    return nil unless sublingual_min_light_dose || sublingual_max_light_dose
    "Light dose: #{sublingual_min_light_dose}#{sublingual_dose_units} -"\
    " #{sublingual_max_light_dose}#{sublingual_dose_units}"
  end

  def common_sublingual_dose_string
    return nil unless sublingual_min_common_dose || sublingual_max_common_dose
    "Common dose: #{sublingual_min_common_dose}#{sublingual_dose_units} -"\
    " #{sublingual_max_common_dose}#{sublingual_dose_units}"
  end

  def strong_sublingual_dose_string
    return nil unless sublingual_min_strong_dose || sublingual_max_strong_dose
    "Strong dose: #{sublingual_min_strong_dose}#{sublingual_dose_units} -"\
    " #{sublingual_max_strong_dose}#{sublingual_dose_units}"
  end

  def heavy_sublingual_dose_string
    return nil unless sublingual_heavy_dose
    "Heavy dose: #{sublingual_heavy_dose}#{sublingual_dose_units}"
  end

  def threshold_intravenous_dose_string
    return nil unless intravenous_threshold_dose
    "Threshold dose: #{intravenous_threshold_dose}#{intravenous_dose_units}"
  end

  def light_intravenous_dose_string
    return nil unless intravenous_min_light_dose || intravenous_max_light_dose
    "Light dose: #{intravenous_min_light_dose}#{intravenous_dose_units} -"\
    " #{intravenous_max_light_dose}#{intravenous_dose_units}"
  end

  def common_intravenous_dose_string
    return nil unless intravenous_min_common_dose || intravenous_max_common_dose
    "Common dose: #{intravenous_min_common_dose}#{intravenous_dose_units} -"\
    " #{intravenous_max_common_dose}#{intravenous_dose_units}"
  end

  def strong_intravenous_dose_string
    return nil unless intravenous_min_strong_dose || intravenous_max_strong_dose
    "Strong dose: #{intravenous_min_strong_dose}#{intravenous_dose_units} -"\
    " #{intravenous_max_strong_dose}#{intravenous_dose_units}"
  end

  def heavy_intravenous_dose_string
    return nil unless intravenous_heavy_dose
    "Heavy dose: #{intravenous_heavy_dose}#{intravenous_dose_units}"
  end
end
