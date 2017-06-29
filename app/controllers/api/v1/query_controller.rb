module Api::V1
  class QueryController < ApplicationController
    rescue_from ApiError, with: :handle_api_error
    before_action :check_params

    def query
      check_params
      response = Watson::Requests.new(text: params['query']).post_input
      check_for_intent_and_parse_substance(response)
      create_response
    end

    private

    def check_params
      fail!(message: 'You must pass a query in the query param') unless params['query']
    end

    def find_substance(name)
      substance = Drug.find_by(name: name)
      substance ||= Drug.where('? = ANY (aliases)', name).first
      substance ||= Substance.find_by(name: name)
      substance
    end

    def check_for_intent_and_parse_substance(response)
      @intent = response[:probable_intent]
      @substance = find_substance(name: response[:substance])
    end

    def create_response
      could_not_determine_intent unless @intent && @intent != 'unknown'
      could_not_determine_substance unless @substance
      message = Response.new(intent: @intent, substance: @substance).message
      render json: { message: message }
    end

    def could_not_determine_substance
      message = "Sorry, but I couldn't determine what substance you were inquiring about"
      render json: { message: message }
    end

    def could_not_determine_intent
      message = "Sorry, but I couldn't tell what you wanted. Right now, you can try 'Tell me about [substance]'"
      render json: { message: message }
    end
  end
end
