class BotController < ApplicationController
  rescue_from ApiError, with: :handle_api_error
  before_action :check_query_params, only: [:text]

  def bot
    connect_client = RecastAI::Connect.new(ENV['RECAST_TOKEN'], 'en')
    reply_info = Recast::Requests.new(conversation: params['message']).reply_to_conversation
    message = create_message_from_info(info: reply_info)
    connect_client.send_message(message, reply_info[:chat_id])
  end

  def text
    text = params['query']
    reply_info = Recast::Requests.new(text: text).parse_text
    message = create_message_from_info(info: reply_info)
    render json: { data: { messages: message } }
  end

  private

  def create_message_from_info(info:)
    response = Response.new(intent: info[:probable_intent], substance: info[:substance],
                            replies: info[:replies], interaction_substance: info[:interaction_substance])
    response.create_reply
  end

  def check_query_params
    fail!(message: 'You must pass a query in the query param') unless params['query']
  end
end
