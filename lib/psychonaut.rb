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
      return unless substance && info
      create_substance_from_info(substance: substance, info: info)
    end

    def create_substance_from_info(substance:, info:)
      binding.pry
    end
  end
end
