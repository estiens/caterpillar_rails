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
end
