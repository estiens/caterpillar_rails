module Api::V1
  class QueryController < ApplicationController
    rescue_from ApiError, with: :handle_api_error
    before_action :check_params

    def query
      check_params
      response = Watson::Requests.new(text: params['query']).post_input
      create_response if check_for_intent_and_parse_substance(response)
    end

    private

    def check_params
      fail!(message: 'You must pass a query in the query param') unless params['query']
    end

    def check_for_intent_and_parse_substance(response)
      @intent = response[:probable_intent]
      could_not_determine_intent && return if @intent == 'unknown'
      @substance = Substance.find_by(name: response[:substance])
      true
    end

    def create_response
      message = Response.new(intent: @intent, substance: @substance).message
      render json: { message: message }
    end

    def could_not_determine_intent
      message = "Sorry, but I couldn't tell what you wanted. Right now, you can try 'Tell me about [substance]'"
      render json: { message: message }
    end
  end
end
