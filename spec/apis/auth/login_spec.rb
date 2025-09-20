require "rails_helper"

RSpec.describe "POST /goodnight/api/v1/auth/login", type: :request do
  let(:user) { create(:user) }

  context "when user_guid params is empty" do
    it "returns 400 missing login credentials" do
      post "/goodnight/api/v1/auth/login", params: { user_guid: "" }, headers: {}

      expect(response).to have_http_status(400)
      expect(json["error"]).to eq("missing login credentials")
    end
  end

  context "when invalid user_guid is sent" do
    it "returns 404 user not found" do
      post "/goodnight/api/v1/auth/login", params: { user_guid: SecureRandom.uuid }, headers: {}

      expect(response).to have_http_status(404)
      expect(json["error"]).to eq("user not found")
    end
  end

  context "when valid user_guid is sent" do
    it "returns 200 and valid auth token" do
      post "/goodnight/api/v1/auth/login", params: { user_guid: user.guid }, headers: {}

      expect(response).to have_http_status(200)

      auth_token = json["data"]["token"]

      get "/goodnight/api/v1/sleep_logs/me", headers: { Authorization: auth_token }

      expect(response).to have_http_status(200)
    end
  end
end
