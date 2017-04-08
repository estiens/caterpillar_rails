class ApplicationController < ActionController::API
  def fail!(message: nil, status: nil, code: nil)
    raise ApiError.new(message: message, status: status, code: code)
  end

  def handle_api_error(exception)
    render json: { message: exception.message, code: exception.code }, status: exception.status
  end
end
