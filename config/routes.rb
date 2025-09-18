Rails.application.routes.draw do
  root "health#health_check"
  get "/health" => "health#health_check"

  post "/sleep/start" => "health#health_check"
  post "/sleep/finish" => "health#health_check"
  get "/sleep_logs/me" => "health#health_check"
  get "/sleep_logs/friends" => "health#health_check"
  post "/user/:user_guid/follow" => "health#health_check"
  post "/user/:user_guid/unfollow" => "health#health_check"

  match "*path", to: "errors#route_not_found", via: :all
end
