Rails.application.config.jwt_secret = ENV.fetch("JWT_SECRET") { "this-is-default-jwt-secret" }
Rails.application.config.jwt_algorithm = "HS256"
