class ApplicationController < ActionController::API
  private

  def render_response(status: 200, data: {}, error: "")
    formatted_data = { data: data, error: error }
    render(status: status, json: formatted_data)
  end
end
