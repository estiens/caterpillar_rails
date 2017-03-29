class ApiError < StandardError
  attr_reader :status
  attr_reader :code

  def initialize(code: nil, status: nil, message: nil)
    @status = status || 422
    @code = code || 'Unprocessable Entity'
    @message = message || 'Something Went Wrong'
  end
end
