module Api::V1
  class QueryController < ApplicationController
    rescue_from ApiError, with: :handle_api_error

    # will be remade into direct request for info
  end
end
