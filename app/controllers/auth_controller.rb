class AuthController < ApplicationController
  def login
    service = AuthService::Login.new(params)
    service.call
    render_response(data: service.result)
  end
end
