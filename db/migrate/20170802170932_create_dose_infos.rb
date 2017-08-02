class CreateDoseInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :dose_infos do |t|
      t.string :insufflated_dose_units
      t.string :insufflated_heavy_dose
      t.string :insufflated_max_common_dose
      t.string :insufflated_max_light_dose
      t.string :insufflated_max_strong_dose
      t.string :insufflated_min_common_dose
      t.string :insufflated_min_light_dose
      t.string :insufflated_min_strong_dose
      t.string :insufflated_threshold_dose
      t.string :intravenous_dose_units
      t.string :intravenous_heavy_dose
      t.string :intravenous_max_common_dose
      t.string :intravenous_max_light_dose
      t.string :intravenous_max_strong_dose
      t.string :intravenous_min_common_dose
      t.string :intravenous_min_light_dose
      t.string :intravenous_min_strong_dose
      t.string :intravenous_threshold_dose
      t.string :oral_dose_units
      t.string :oral_heavy_dose
      t.string :oral_max_common_dose
      t.string :oral_max_light_dose
      t.string :oral_max_strong_dose
      t.string :oral_min_common_dose
      t.string :oral_min_light_dose
      t.string :oral_min_strong_dose
      t.string :oral_threshold_dose
      t.string :sublingual_dose_units
      t.string :sublingual_heavy_dose
      t.string :sublingual_max_common_dose
      t.string :sublingual_max_light_dose
      t.string :sublingual_max_strong_dose
      t.string :sublingual_min_common_dose
      t.string :sublingual_min_light_dose
      t.string :sublingual_min_strong_dose
      t.string :sublingual_threshold_dose
      t.string :smoked_dose_units
      t.string :smoked_heavy_dose
      t.string :smoked_max_common_dose
      t.string :smoked_max_light_dose
      t.string :smoked_max_strong_dose
      t.string :smoked_min_common_dose
      t.string :smoked_min_light_dose
      t.string :smoked_min_strong_dose
      t.string :smoked_threshold_dose
      t.references :drug
      t.timestamps
    end
  end
end
