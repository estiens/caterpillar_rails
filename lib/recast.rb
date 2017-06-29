require 'recastai'

module Recast
  class Requests
    def initialize(text:)
      @text = text
      @client = RecastAI::Client.new(ENV['RECAST_TOKEN'])
      @response = nil
      @substance = nil
      @intent = nil
    end

    def send_text
      @response = @client.request.analyse_text(@text)
      parse_substance
      parse_intent
      { probable_intent: @intent, substance: @substance }
    end

    def parse_substance
      possible_substance = @response&.entities&.select { |e| e.name == 'substance' }.first
      @substance = possible_substance.value if possible_substance.respond_to?(:value)
    end

    def parse_intent
      @intent = @response&.intents&.first&.slug
    end
  end
end
