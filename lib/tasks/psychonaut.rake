namespace :psychonaut do
  task get_info_for_substances: :environment do
    path = Rails.root.join('lib', 'reference') + 'psychonaut_api_substance_list.yml'
    substance_list = YAML.safe_load(File.read(path))
    substance_list['substances'].each do |substance|
      begin
        requester = Psychonaut::SubstanceRequester.new(subject: substance, force: false)
        name = requester.create_substance_from_info
        if name == 'skipped'
          puts "#{substance} skipped"
        elsif name
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
