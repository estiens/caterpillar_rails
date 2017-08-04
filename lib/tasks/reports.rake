namespace :reports do
  task missing_dose_units: :environment do
    missing_oral_dose_units = []
    missing_insufflated_dose_units = []
    missing_iv_dose_units = []
    missing_smoked_dose_units = []
    missing_sublingual_dose_units = []

    DoseInfo.all.each do |d|
      missing_insufflated_dose_units << d if d.insufflation_dose_string && !d.insufflated_dose_units
      missing_oral_dose_units << d if d.oral_dose_string && !d.oral_dose_units
      missing_iv_dose_units << d if d.intravenous_dose_string && !d.intravenous_dose_units
      missing_smoked_dose_units << d if d.smoked_dose_string && !d.smoked_dose_units
      missing_sublingual_dose_units << d if d.sublingual_dose_string && !d.sublingual_dose_units
    end
    mid = missing_insufflated_dose_units.map { |d| Drug.find(d.drug_id).name }
    puts "Missing Insufflation Dose Units: #{mid.join(', ')}"

    mod = missing_oral_dose_units.map { |d| Drug.find(d.drug_id).name }
    puts "Missing Oral Dose Units: #{mod.join(', ')}"

    mivd = missing_iv_dose_units.map { |d| Drug.find(d.drug_id).name }
    puts "Missing IV Dose Units: #{mivd.join(', ')}"

    msd = missing_smoked_dose_units.map { |d| Drug.find(d.drug_id).name }
    puts "Missing Smoked Dose Units: #{msd.join(', ')}"

    msld = missing_sublingual_dose_units.map { |d| Drug.find(d.drug_id).name }
    puts "Missing Sublingual Dose Units: #{msld.join(', ')}"
  end
end
