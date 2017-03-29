module Watson
  BASE_URI = 'https://gateway.watsonplatform.net/conversation/api/v1'.freeze
  WORKSPACE_ID = 'c4a97805-e49c-4db9-82a4-40f06ac7c905'.freeze
  HEADERS = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }.freeze

  class Requests
    def initialize(context: nil, entities: nil, intents: nil, text: nil)
      @username = ENV['WATSON_USERNAME']
      @password = ENV['WATSON_PASSWORD']
      @version = '2017-02-03'
      @context = context
      @entities = entities
      @intents = intents
      @text = text
    end

    def post_input
      body = { input: { text: @text }, alternate_intents: true, context: @context }.to_json
      options = { body: body, basic_auth: auth, headers: HEADERS }
      response = HTTParty.post(url_for_messages, options)
      parse_response_for_methods(response)
    end

    private

    def auth
      { username: @username, password: @password }
    end

    def url_for_messages
      "#{BASE_URI}/workspaces/#{WORKSPACE_ID}/message?version=#{@version}"
    end

    def parse_response_for_methods(response)
      json_body = JSON.parse(response.body)
      probable_intent = parse_body_for_intent(json_body)
      substance = parse_body_for_substance(json_body)
      { probable_intent: probable_intent, substance: substance }
    end

    def parse_body_for_intent(json_body)
      found_intents = json_body['intents']
      probable_intent = found_intents.first['intent'] if found_intents.first['confidence'] > 0.15
      probable_intent || 'unknown'
    rescue
      'unknown'
    end

    def parse_body_for_substance(json_body)
      found_entities = json_body['entities']
      found_substance = found_entities.select { |h| h['entity'] == 'Substances' }.first
      found_substance['value'] || 'unknown'
    rescue
      'unknown'
    end
  end
end
