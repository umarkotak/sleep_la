class ErrorsController < ApplicationController
  def route_not_found
    render_response(
      status: 404,
      error: "route not found"
    )
  end
end
