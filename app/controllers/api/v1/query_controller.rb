module Api::V1
  class QueryController < ApplicationController
    rescue_from ApiError, with: :handle_api_error
    before_action :check_params

    def query
      check_params
      response = Recast::Requests.new(text: params['query']).send_text
      check_for_intent_and_parse_substance(response)
      create_response
    end

    private

    def check_params
      fail!(message: 'You must pass a query in the query param') unless params['query']
    end

    def find_substance(name:)
      substance = Drug.find_by(name: name)
      substance ||= Drug.where('? = ANY (aliases)', name).first
      substance
    end

    def check_for_intent_and_parse_substance(response)
      @intent = response[:probable_intent]
      @substance = find_substance(name: response[:substance])
    end

    def create_response
      message = if !@intent || @intent == 'unknown'
                  could_not_determine_intent
                elsif !@substance
                  could_not_determine_substance
                else
                  Response.new(intent: @intent, substance: @substance).message
                end
      render json: { message: message }
    end

    def could_not_determine_substance
      message = "Sorry, but I couldn't determine what substance you were inquiring about, "
      message += "but I think you wanted to know about #{@intent}"
      message
    end

    def could_not_determine_intent
      if @substance
        message = "I could tell you want info about #{substance_name}. "
        message += "I couldn't tell what kind of info. Try info, dosage, effects, or testing"
      else
        message = complete_unknown_message
      end
      message
    end

    def complete_unknown_message
      message = "Sorry, but I couldn't tell what you wanted."
      message += "Right now, you can try 'Tell me about [substance]'"
      message
    end
  end
end
