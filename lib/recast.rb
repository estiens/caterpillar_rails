require 'recastai'

module Recast
  class Requests
    def initialize(conversation: nil, text: nil)
      @client = RecastAI::Request.new(ENV['RECAST_TOKEN'])
      @response = nil
      @substance = nil
      @intent = nil
      @replies = nil
      @conversation = conversation
      @text = text
    end

    def parse_text
      @response = @client.converse_text(@text)
      parse_reply
      { replies: @replies, probable_intent: @intent, substance: @substance }
    end

    def reply_to_conversation
      incoming_text = @conversation.dig('attachment', 'content')
      sender_id = @conversation['participant']
      chat_id = @conversation['conversation']
      @response = @client.converse_text(incoming_text, conversation_token: sender_id)
      parse_reply
      { replies: @replies, probable_intent: @intent, substance: @substance, chat_id: chat_id }
    end

    private

    def parse_reply
      parse_replies
      parse_substance
      parse_intent
    end

    def parse_replies
      reply_responses = @response.replies
      return if reply_responses.blank?
      @replies = @response.replies.map { |r| { type: 'text', content: r } }
    end

    def parse_substance
      possible_substance = @response&.entities&.select { |e| e.name == 'substance' }.first
      @substance = possible_substance.value if possible_substance.respond_to?(:value)
    end

    def parse_intent
      @intent = @response.intents.select { |i| i.confidence > 0.90 }&.first&.slug
    end
  end
end
