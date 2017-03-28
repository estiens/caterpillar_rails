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
      found_intents = json_body['intents'] || [{}]
      found_entities = json_body['entities'] || [{}]
      found_substance = found_entities.select { |h| h['entity'] == 'Substances' }.first || {}
      probable_intent = found_intents.first['intent']
      substance_type = found_substance['value']
      { probable_intent: probable_intent, substance: substance_type }
    end
  end
end
