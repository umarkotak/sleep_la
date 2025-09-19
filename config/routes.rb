Rails.application.routes.draw do
  root "health#health_check"
  get "/goodnight/api/health" => "health#health_check"

  post "/goodnight/api/v1/sleep/start" => "sleep_logs#start_sleep"
  post "/goodnight/api/v1/sleep/finish" => "sleep_logs#finish_sleep"
  get "/goodnight/api/v1/sleep_logs/me" => "sleep_logs#get_my_sleep_logs"
  get "/goodnight/api/v1/sleep_logs/friends" => "sleep_logs#get_friends_sleep_logs"
  post "/goodnight/api/v1/user/:user_guid/follow" => "users#follow"
  post "/goodnight/api/v1/user/:user_guid/unfollow" => "users#unfollow"

  match "*path", to: "errors#route_not_found", via: :all
end
