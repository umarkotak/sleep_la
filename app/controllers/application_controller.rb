class ApplicationController < ActionController::API
  private

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
