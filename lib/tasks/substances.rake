namespace :substances do
  task build_substance_models: :environment do
    substance_list = TripSit::SubstanceRequester.get_drug_list
    if substance_list.empty?
      path = Rails.root.join('lib', 'reference') + 'psychonaut_api_substance_list.yml'
      substance_list = YAML.safe_load(File.read(path))['substances']
    end
    substance_list.each do |substance|
      begin
        requester = TripSit::SubstanceRequester.new(subject: substance, force: false)
        name = requester.create_substance_from_info
        if name
          puts "#{substance} updated"
        else
          puts "#{substance} skipped"
        end
      rescue
        next
      end
    end
  end
end
