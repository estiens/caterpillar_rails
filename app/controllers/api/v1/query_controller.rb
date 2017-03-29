module Api::V1
  class QueryController < ApplicationController
    rescue_from ApiError, with: :handle_api_error
    before_action :check_params

    def query
      check_params
      response = Watson::Requests.new(text: params['query']).post_input
      return unless check_for_intent_and_substance(response)
      send_information(intent: @intent, substance: @substance)
    end

    private

    def check_params
      fail!(message: 'You must pass a query in the query param') unless params['query']
    end

    def check_for_intent_and_substance(response)
      @intent = response[:probable_intent]
      could_not_determine_intent && return if @intent == 'unknown'
      @substance = Substance.find_by(name: response[:substance])
      cannot_find_substance && return unless @substance
      true
    end

    def send_information(intent:, substance:)
      message = case intent
                when 'substance_profile'
                  substance.substance_profile
                else
                  could_not_determine_intent
                end
      render json: { message: message }
    end

    def could_not_determine_intent
      message = "Sorry, but I couldn't tell what you wanted. Right now, you can try 'Tell me about [substance]'"
      render json: { message: message }
    end

    def cannot_find_substance
      render json: { message: "I'm sorry, but I don't have any information about that" }
    end

    def fail!(message: nil, status: nil, code: nil)
      raise ApiError.new(message: message, status: status, code: code)
    end

    def handle_api_error(exception)
      render json: { message: exception.message, code: exception.code }, status: exception.status
    end
  end
end
