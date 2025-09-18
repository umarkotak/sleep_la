Rails.application.routes.draw do
  root "health#health_check"
  get "/health" => "health#health_check"

  post "/sleep/start" => "sleep_logs#start_sleep"
  post "/sleep/finish" => "sleep_logs#finish_sleep"
  get "/sleep_logs/me" => "sleep_logs#get_my_sleep_logs"
  get "/sleep_logs/friends" => "sleep_logs#get_friends_sleep_logs"
  post "/user/:user_guid/follow" => "users#follow"
  post "/user/:user_guid/unfollow" => "users#unfollow"

  match "*path", to: "errors#route_not_found", via: :all
end
