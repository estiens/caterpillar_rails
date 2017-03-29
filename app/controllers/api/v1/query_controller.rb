module Api::V1
  class QueryController < ApplicationController
    rescue_from ApiError, with: :handle_api_error
    before_action :check_query_param

    def query
      watson = Watson::Requests.new(text: params['query'])
      response = watson.post_input
      substance = Substance.find_by(name: response[:substance])
      cannot_find_substance(response[:substance]) && return unless substance
      send_information(intent: response[:probable_intent], substance: substance)
    end
  end

  private

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
    "Sorry, but I couldn't tell what you wanted. Right now, you can try 'Tell me about [substance]'"
  end

  def cannot_find_substance(name)
    render json: { message: "I'm sorry, but I don't have any information about #{name}" }
  end

  def check_query_param
    fail!(message: 'You must pass a query in the query param') unless params['query']
  end

  def fail!(message: nil, status: nil, code: nil)
    raise ApiError.new(message: message, status: status, code: code)
  end

  def handle_api_error(exception)
    render json: { message: exception.message, code: exception.code }, status: exception.status
  end
end
