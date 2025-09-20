class ApplicationController < ActionController::API
  rescue_from StandardError,
              with: :handle_error

  private

  def handle_error(e)
    status = e.http_status if e.respond_to?(:http_status)
    status ||= 500
    render_response(status: status, error: e.message)
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
