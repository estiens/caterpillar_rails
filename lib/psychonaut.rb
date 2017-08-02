module Psychonaut
  include HTTParty

  BASE_URL = 'https://psychonautwiki.org/w/api.php?action=browsebysubject&format=json'.freeze

  class SubstanceRequester

    def initialize(substance:, force: false)
      @info = nil
      @substance = substance
      @force = force
    end

    def info_lookup
      lookup_substance(@substance.name)
      try_aliases if @info.blank?
    end

    def write_information_for_substance
      info_lookup
      return if @info.blank?
      create_dosage_information unless @substance.dose_info && !@force
      create_other_information
    end

    private

    def create_dosage_information
      column_names = DoseInfo.column_names.select { |attr| attr.include?('dose') }
      dosage_info = DoseInfo.where(drug_id: @substance.id).first_or_initialize
      column_names.each do |column|
        dosage_info.write_attribute(column.to_sym, extract_all_values_from_key(key: column))
      end
      dosage_info.save
    end

    def create_other_information
      return if @substance.chemical_class && !@force
      @substance.toxicity_info = extract_all_values_from_key(key: 'toxicity')
      @substance.chemical_class = extract_all_values_from_key(key: 'chemical_class')
      @substance.addiction_potential = extract_all_values_from_key(key: 'addiction_potential')
      @substance.cross_tolerance = extract_all_values_from_key(key: 'cross-tolerance')
      @substance.time_to_full_tolerance = extract_all_values_from_key(key: 'time_to_full_tolerance')
      @substance.time_to_zero_tolerance = extract_all_values_from_key(key: 'time_to_zero_tolerance')
      @substance.save
    end

    def lookup_substance(name)
      encoded_subject = name.encode('ASCII', invalid: :replace, undef: :replace, replace: '')
      response = HTTParty.get(BASE_URL + "&subject=#{encoded_subject}")
      body = JSON.parse(response.body)
      @info = body.dig('query', 'data')
    end

    def try_aliases
      return if @substance.aliases.blank?
      @substance.aliases.each do |name|
        @info = lookup_substance(name)
        return @info if @info.present?
      end
    end

    def clean_extracted_values!(extracted_values)
      extracted_values.map! { |value| value.gsub('#0#', '') }
      extracted_values.map! { |value| value.tr('_', ' ') }
      extracted_values.map! { |value| value.gsub('[[', '') }
      extracted_values.map! { |value| value.gsub(']]', '') }
    end

    def extract_all_values_from_key(key:)
      array_of_values = @info.select { |h| h['property'].casecmp(key).zero? }.first['dataitem']
      extracted_values = array_of_values.map { |hash| hash['item'] }
      clean_extracted_values!(extracted_values)
      extracted_values.join(', ')
    rescue
      return nil
    end
  end
end
