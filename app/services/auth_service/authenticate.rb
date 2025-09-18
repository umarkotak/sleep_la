module AuthService
  class Authenticate < BaseService
    def initialize(auth_token)
      @auth_token = auth_token
    end

    def call
      if @auth_token.blank?
        @result = nil
        return
      end

      # for simplicity, I use guid as auth token
      @result = User.find_by!(guid: @auth_token)

    rescue ActiveRecord::RecordNotFound
      @result = nil
    end
  end
end
