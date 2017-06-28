module TripSit
  include HTTParty

  BASE_URL = 'http://tripbot.tripsit.me/api/tripsit/getDrug'.freeze

  class SubstanceRequester
    def initialize(subject:, force: true)
      @subject = subject
      @force = force
      @name = nil
      @info = nil
      @new_substance = nil
    end

    def info_lookup
      encoded_subject = @subject.encode('ASCII', invalid: :replace, undef: :replace, replace: '')
      response = HTTParty.get(BASE_URL + "?name=#{encoded_subject}")
      body = JSON.parse(response.body)
      @name = body['data'].first['name']
      @info = body['data'].first['properties']
      return false unless @name && @info
      true
    end

    def create_substance_from_info
      if info_lookup
        @new_substance = Drug.find_or_create_by(name: @name)
        write_summaries
        write_other_values
      end
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
