module AuthService
  class Authenticate < BaseService
    SECRET = Rails.application.config.jwt_secret
    ALG = Rails.application.config.jwt_algorithm
    ISSUER = Rails.application.config.jwt_issuer

    def initialize(auth_token)
      @auth_token = auth_token
    end

    def call
      validate
      execute_logic
      @result
    end

    private

    def validate
      raise Errors::Unauthorized if @auth_token.blank?

      raise Errors::Unauthorized if !(@auth_token.start_with?("Bearer ") && @auth_token.split(" ").size == 2)
    end

    def execute_logic
      token = @auth_token.split(" ").last

      raise Errors::Unauthorized if token.blank?

      decoded, _header = JWT.decode(
        token,
        SECRET,
        true,
        {
          algorithm: ALG,
          iss: ISSUER,
          verify_iss: true
        }
      )

      user_guid = decoded["sub"].presence

      user = User.find_by(guid: user_guid)

      raise Errors::UserNotFound if user.blank?

      @result = user

    rescue JWT::DecodeError, JWT::InvalidIssuerError, JWT::IncorrectAlgorithm
      raise Errors::Unauthorized
    end
  end
end
