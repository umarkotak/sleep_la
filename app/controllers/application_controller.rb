class ApplicationController < ActionController::API
  rescue_from StandardError,
              with: :handle_error

  private

  def handle_error(e)
    error_message = e&.message.to_s
    status = 500

    case error_message
    when ConstErr::UNAUTHORIZED
      status = 401
    when ConstErr::MUST_WAKE_FIRST
      status = 400
    when ActiveRecord::RecordNotFound
      status = 404
    end

    render_response(status: status, error: error_message)
  end

  def render_response(status: 200, data: {}, error: "")
    formatted_data = { data: data, error: error }
    render(status: status, json: formatted_data)
  end

  def authenticate_user
    auth_service = AuthService::Authenticate.new(request.headers["Authorization"].to_s)
    auth_service.call
    @user = auth_service.result
  end
end
