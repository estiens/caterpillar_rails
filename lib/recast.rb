module Recast
  class Requests
    def initialize(text:)
      @text = text
      @client = RecastAI::Client.new(ENV['RECAST_TOKEN'])
    end

    def send_text
      response = @client.request.analyse_text(text)
      substance = response&.entities&.first&.value
      probable_intent = response&.intents&.first&.slug
      { probable_intent: probable_intent, substance: substance }
    end
  end
end
