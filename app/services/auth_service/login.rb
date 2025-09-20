module AuthService
  class Login < BaseService
    SECRET = Rails.application.config.jwt_secret
    ALG = Rails.application.config.jwt_algorithm
    ISSUER = Rails.application.config.jwt_issuer

    def initialize(params)
      # for simplicity, i only use guid for auth. ideally this should be something like email + password
      # since the docs didn't specify any auth mechanism, i went with the simplest one
      @params = params.permit(:user_guid)
    end

    def call
      validate
      execute_logic
      @result
    end

    private

    def validate
      raise Errors::MissingLoginCredentials if @params[:user_guid].blank?
    end

    def execute_logic
      user = User.find_by(guid: @params[:user_guid])

      raise Errors::UserNotFound if user.blank?

      payload = {
        iss: ISSUER,
        sub: user.guid,
        iat: Time.current.to_i,
        jti: SecureRandom.uuid
      }

      @result = {
        token: "Bearer #{JWT.encode(payload, SECRET, ALG)}"
      }
    end
  end
end
