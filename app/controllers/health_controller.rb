class HealthController < ApplicationController
  def health_check
    render_response(
      data: {
        status: "ok"
      }
    )
  end
end
