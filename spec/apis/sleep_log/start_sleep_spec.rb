require "rails_helper"

RSpec.describe SleepLogsController, type: :request do
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
      post "/goodnight/api/v1/sleep/start", headers: {}

      expect(response).to have_http_status(401)
    end
  end

  context "when the user call sleep for the second time" do
    it "raises MUST_WAKE_FIRST and does not create a new log" do
      post "/goodnight/api/v1/sleep/start", headers: headers

      post "/goodnight/api/v1/sleep/start", headers: headers

      expect(response).to have_http_status(400)
      expect(json["error"]).to eq("must wake first")
    end
  end

  context "when everything is valid" do
    it "creates a sleep log with the current time and returns it" do
      frozen_time = Time.current
      allow(Time).to receive(:current).and_return(frozen_time)

      post "/goodnight/api/v1/sleep/start", headers: headers

      expect(response).to have_http_status(200)

      sleep_log = UserSleepLog.order(id: :desc).last
      expect(sleep_log.user).to eq(user)
      expect(sleep_log.sleep_at.to_i).to eq(frozen_time.to_i)
      expect(sleep_log.sleep_date).to eq(frozen_time.to_date)
      expect(sleep_log.wake_at).to be_nil
    end
  end
end
