Rails.application.config.jwt_secret = ENV.fetch("JWT_SECRET") { "this-is-default-jwt-secret" }
Rails.application.config.jwt_algorithm = "HS256"
Rails.application.config.jwt_issuer = "good-night-sleep-la-app"
