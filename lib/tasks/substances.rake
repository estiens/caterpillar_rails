namespace :substances do
  task build_substance_models: :environment do
    path = Rails.root.join('lib', 'reference') + 'psychonaut_api_substance_list.yml'
    substance_list = YAML.safe_load(File.read(path))
    substance_list['substances'].each do |substance|
      begin
        requester = TripSit::SubstanceRequester.new(subject: substance, force: true)
        name = requester.create_substance_from_info
        if name
          puts "#{substance} updated"
        else
          puts "#{substance} not found"
        end
      rescue
        next
      end
    end
  end
end
