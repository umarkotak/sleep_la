class UsersController < ApplicationController
  def follow
    authenticate_user
    service = UserService::Follow.new(@user, params)
    service.call
    render_response(data: service.result)
  end

  def unfollow
    authenticate_user
    service = UserService::Unfollow.new(@user, params)
    service.call
    render_response(data: service.result)
  end
end
