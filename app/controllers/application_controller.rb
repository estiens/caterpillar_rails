class ApplicationController < ActionController::API

  def query
    must_pass_params && return unless params['query']
    watson = Watson::Requests.new(text: params['query'])
    response = watson.post_input
    substance = Substance.find_by(name: response[:substance])
    cannot_find_substance(response[:substance]) && return unless substance
    send_information(intent: response[:probable_intent], substance: substance)
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
    "Sorry, but I couldn't tell what you wanted. Right now, you can try 'Tell me about [substance]'"
  end

  def must_pass_params
    render json: { message: 'You must pass a query in the query param' }, status: 422
  end

  def cannot_find_substance(name)
    render json: { message: "I'm sorry, but I don't have any information about #{name}" }
  end
end
