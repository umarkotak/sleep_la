Rails.application.routes.draw do
  root "health#health_check"
  get "/health" => "health#health_check"

  match "*path", to: "errors#route_not_found", via: :all
end
