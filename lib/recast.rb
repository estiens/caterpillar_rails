require 'sapcai'

module Recast
  class Requests
    def initialize(conversation: nil, text: nil)
      @client = Sapcai::Request.new(ENV['RECAST_TOKEN'])
      @response = nil
      @substance_a = nil
      @substance_b = nil
      @intent = nil
      @replies = nil
      @conversation = conversation
      @text = text
    end

    def parse_text
      @response = @client.converse_text(@text, language: 'en')
      parse_reply
      { replies: @replies, probable_intent: @intent, substance: @substance_a, interaction_substance: @substance_b }
    end

    def reply_to_conversation
      incoming_text = @conversation.dig('attachment', 'content')
      sender_id = @conversation['participant']
      chat_id = @conversation['conversation']
      @response = @client.converse_text(incoming_text, language: 'en', conversation_token: sender_id)
      parse_reply
      { replies: @replies, probable_intent: @intent, substance: @substance_a,
        interaction_substance: @substance_b, chat_id: chat_id }
    end

    private

    def parse_reply
      parse_replies
      parse_substances
      parse_intent
    end

    def parse_replies
      reply_responses = @response.replies
      return if reply_responses.blank?
      @replies = @response.replies.map { |r| { type: 'text', content: r } }
    end

    def parse_substances
      possible_substances = @response&.entities&.select { |e| e.name == 'substance' }
      @substance_a = possible_substances.first.value if possible_substances.first.respond_to?(:value)
      @substance_b = possible_substances[1]&.value
    end

    def parse_intent
      @intent = @response.intents.select { |i| i.confidence > 0.50 }&.first&.slug
    end
  end
end
