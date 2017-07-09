namespace :substances do
  desc 'build substance models'
  # invoke with bx rake substances:build_substance_models\[true\] to force updating of current substances
  # invoke with bx rake substances:build_substance_models to only create new substances

  task :build_substance_models, [:force] => :environment do |_t, args|
    force = args[:force].present?
    substance_list = TripSit::SubstanceRequester.tripsit_drug_list
    raise 'Could not fetch substances' if substance_list.blank?
    substance_list.each do |substance|
      begin
        ts_requester = TripSit::SubstanceRequester.new(subject: substance, force: force)
        new_substance = ts_requester.create_substance_from_info
        if new_substance == 'skipped'
          puts "#{substance} skipped"
        elsif new_substance
          puts "#{substance} updated - fetching more information..."
          pn_requester = Psychonaut::SubstanceRequester.new(substance: new_substance)
          puts 'updated info' if pn_requester.add_extra_information
        else
          puts "#{substance} not found"
        end
      rescue
        next
      end
    end
  end

  desc 'load current reagent info for substances'
  task load_reagent_info: :environment do
    reagent_info = YAML.load_file(Rails.root.join('lib', 'reference', 'more_reagent_tests.yml'))
    reagent_info.each do |info|
      drug = Drug.find_with_aliases(info['substance'])
      next unless drug
      puts "writing test info for drug: #{drug.substance_name}"
      drug.marquis_test = info['marquis']
      drug.mandelin_test = info['mandelin']
      drug.mecke_test = info['mandelin']
      drug.folin_test = info['folin']
      drug.froehde_test = info['froehde']
      drug.liebermann_test = info['liebermann']
      drug.robadope_test = info['robadope']
      drug.simons_test = info['simons']
      drug.ehrlic_test = info['ehrlic']
      drug.gallic_acid_test = info['gallic']
      drug.scott_test = info['scott']
      drug.save
    end
    reagent_info = YAML.load_file(Rails.root.join('lib', 'reference', 'reagent_test.yml'))
    reagent_info.each do |info|
      drug = Drug.find_with_aliases(info['Substance'])
      next unless drug
      puts "writing test info for drug: #{drug.substance_name}"
      drug.marquis_test ||= info['Marquis']
      drug.mandelin_test ||= info['Mandelin']
      drug.mecke_test ||= info['Mecke']
      drug.liebermann_test ||= info['Liebermann']
      drug.froehde_test ||= info['Froehde']
      drug.gallic_acid_test ||= info['Gallic acid']
      drug.ehrlic_test ||= info['Ehrlich']
      drug.save
    end
  end
end
