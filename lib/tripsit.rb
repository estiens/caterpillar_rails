module TripSit
  include HTTParty

  BASE_URL = 'http://tripbot.tripsit.me/api/tripsit'.freeze
  DRUG_LIST_URL = BASE_URL + '/getAllDrugNames'
  DRUG_INFO_URL = BASE_URL + '/getDrug'
  DRUG_INTERACTION_URL = BASE_URL + '/getInteraction'

  class SubstanceRequester
    def initialize(subject:, force: true)
      @subject = subject
      @force = force
      @name = nil
      @info = nil
      @new_substance = nil
    end

    def self.tripsit_drug_list
      response = HTTParty.get(DRUG_LIST_URL)
      body = JSON.parse(response.body)
      body.dig('data')&.first
    end

    def self.interaction_lookup(drug1:, drug2:)
      response = HTTParty.get(DRUG_INTERACTION_URL + "?drugA=#{drug1}&drugB=#{drug2}")
      body = JSON.parse(response.body)
      status = body['data'].first['status']
      note = body['data'].first['note']
      { status: status, note: note }
    rescue
      { status: nil, note: nil }

    end

    def info_lookup
      encoded_subject = @subject.encode('ASCII', invalid: :replace, undef: :replace, replace: '')
      response = HTTParty.get(DRUG_INFO_URL + "?name=#{encoded_subject}")
      body = JSON.parse(response.body)
      @name = body['data'].first['name']
      @info = body['data'].first['properties']
      return false unless @name && @info
      true
    end

    def create_substance_from_info
      return false unless info_lookup
      @new_substance = Drug.find_by(name: @name)
      return false unless @force || @new_substance.nil?
      @new_substance = Drug.find_or_create_by(name: @name)
      write_summaries
      write_other_values
      return @new_substance.name if @new_substance.save
      false
    end

    def write_summaries
      @new_substance.dose_summary = @info['dose']
      @new_substance.onset_summary = @info['onset']
      @new_substance.duration_summary = @info['duration']
      @new_substance.drug_summary = @info['summary']
      @new_substance.general_advice = @info['general_advice']
      @new_substance.full_response = @info
    end

    def write_other_values
      @new_substance.after_effects = @info['after-effects']
      effects = @info['effects']&.split(', ')&.map! { |e| e.downcase.delete('.') }
      @new_substance.effects = effects
      @new_substance.categories = @info['categories']
      @new_substance.aliases = @info['aliases']
      @new_substance.test_kits = @info['test-kits']
      @new_substance.detection = @info['detection']
      @new_substance.marquis = @info['marquis']
      @new_substance.avoid = @info['avoid']
    end
  end
end
