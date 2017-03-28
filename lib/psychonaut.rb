module Psychonaut
  include HTTParty

  BASE_URL = 'https://psychonautwiki.org/w/api.php?action=browsebysubject&format=json'.freeze

  class SubstanceRequester
    def initialize(subject:)
      @subject = subject
    end

    def info_lookup
      response = HTTParty.get(BASE_URL + "&subject=#{@subject}")
      body = JSON.parse(response.body)
      substance = body.dig('query', 'subject')&.gsub('#0#', '')
      info = body.dig('query', 'data')
      { substance_name: substance, info: info }
    end

    def create_substance_from_info
      substance_information = info_lookup
      substance_name = substance_information[:substance_name]
      substance_info = substance_information[:info]
      return unless substance_name.present? && substance_info.present?
      substance = Substance.find_or_create_by(name: substance_name)
      make_info_keys_consistent!(info: substance_info)
      extract_all_values(substance: substance, info: substance_info)
      set_alternate_name(substance: substance, info: substance_info)
      substance.save
    end

    private

    def set_alternate_name(substance:, info:)
      skey = info.select { |h| h['property'] == '_SKEY' }
      data_item = skey.first['dataitem']
      name = data_item.first['item']
      substance.alternate_name = name if name != substance.name
    rescue
      nil
    end

    def make_info_keys_consistent!(info:)
      change_hash_keys!(info: info, current_key: 'cross-tolerance', new_key: 'cross_tolerance')
      change_hash_keys!(info: info, current_key: 'dangerousinteraction', new_key: 'dangerous_interactions')
      change_hash_keys!(info: info, current_key: 'effect', new_key: 'effects')
    end

    def change_hash_keys!(info:, current_key:, new_key:)
      hash = info.select { |h| h['property'].casecmp(current_key).zero? }.first
      return unless hash
      hash['property'] = new_key
    end

    def clean_extracted_values!(extracted_values)
      extracted_values.map! { |value| value.gsub('#0#', '') }
      extracted_values.map! { |value| value.tr('_', ' ') }
      extracted_values.map! { |value| value.gsub('[[', '') }
      extracted_values.map! { |value| value.gsub(']]', '') }
    end

    def extract_all_values(substance:, info:)
      possible_keys.each do |key|
        begin
          array_of_values = info.select { |h| h['property'].casecmp(key).zero? }.first['dataitem']
          extracted_values = array_of_values.map { |hash| hash['item'] }
          clean_extracted_values!(extracted_values)
          value_text = extracted_values.join(', ')
          substance.send("#{key}=", value_text)
        rescue
          next
        end
      end
      substance.full_response = info
    end

    def possible_keys
      path = Rails.root.join('lib', 'reference') + 'psychonaut_keys.yml'
      yml = YAML.safe_load(File.read(path)).with_indifferent_access
      yml[:keys]
    end
  end
end
