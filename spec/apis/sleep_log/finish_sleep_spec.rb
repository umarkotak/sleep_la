require "rails_helper"

RSpec.describe "POST /goodnight/api/v1/sleep/finish", type: :request do
  let(:user) { create(:user) }

  let(:auth_token) do
    AuthService::Login.new(ActionController::Parameters.new(user_guid: user.guid)).call
  end

  let(:headers) { {
    Authorization: auth_token["token"]
  } }

  context "when header authorization is empty" do
    let(:user) { nil }

    it "returns 401 unauthorized" do
      post "/goodnight/api/v1/sleep/finish", headers: {}

      expect(response).to have_http_status(401)
    end
  end

  context "when the user call finish when there is no sleep for the second time" do
    it "returns 400 must sleep first" do
      post "/goodnight/api/v1/sleep/finish", headers: headers

      expect(response).to have_http_status(400)
      expect(json["error"]).to eq("must sleep first")
    end
  end

  context "when everything is valid" do
    it "returns 200 and clock out for wake up" do
      post "/goodnight/api/v1/sleep/start", headers: headers

      post "/goodnight/api/v1/sleep/finish", headers: headers

      expect(response).to have_http_status(200)

      sleep_log = UserSleepLog.order(id: :desc).last
      expect(sleep_log.user).to eq(user)
      expect(sleep_log.wake_at).not_to be_nil
    end
  end
end
