require "rails_helper"

RSpec.describe "GET /goodnight/api/v1/sleep_logs/me", type: :request do
  let(:user) { create(:user) }

  let(:auth_token) do
    AuthService::Login.new(ActionController::Parameters.new(user_guid: user.guid)).call
  end

  let(:headers) { {
    Authorization: auth_token["token"]
  } }

  let!(:user_sleep_logs) do
    (1..7).map do |i|
      sleep_at = Time.zone.parse("2025-01-01 00:00:00") + i.hours
      wake_at  = sleep_at + 1.hour
      create(
        :user_sleep_log,
        user: user,
        sleep_date: sleep_at.to_date,
        sleep_at: sleep_at,
        wake_at: wake_at,
        duration_second: (wake_at - sleep_at).to_i,
        created_at: sleep_at
      )
    end
  end

  let!(:other_user) { create(:user) }
  let!(:other_user_sleep_logs) do
    (1..4).map do |i|
      sleep_at = Time.zone.parse("2025-04-01 00:00:00") + i.hours
      wake_at  = sleep_at + 1.hour
      create(
        :user_sleep_log,
        user: other_user,
        sleep_date: sleep_at.to_date,
        sleep_at: sleep_at,
        wake_at: wake_at,
        duration_second: (wake_at - sleep_at).to_i,
        created_at: sleep_at
      )
    end
  end

  context "when user is blank" do
    it "return 401 unauthorized" do
      get "/goodnight/api/v1/sleep_logs/me", headers: {}

      expect(response).to have_http_status(401)
    end
  end

  context "when sending invalid ordering params" do
    it "returns 400 invalid ordering" do
      get "/goodnight/api/v1/sleep_logs/me", params: { order: "created_at desc" }, headers: headers

      expect(response).to have_http_status(400)
      expect(json["error"]).to eq("invalid ordering")
    end
  end

  context "with default params" do
    it "returns 200 and uses the default default params for fetching user sleep logs" do
      get "/goodnight/api/v1/sleep_logs/me", headers: headers

      expect(json["data"]["user_sleep_logs"].size).to eq(user_sleep_logs.size)

      # match sleep logs order based on id desc
      returned_ids = json["data"]["user_sleep_logs"].map { |h| h["id"] }
      expect(returned_ids).to eq(UserSleepLog.where(user: user).order("id desc").pluck(:id))

      expect(json["data"]["user_sleep_logs"].first)
        .to eq({
          "id" => user_sleep_logs.last.id,
          "created_at" => user_sleep_logs.last.created_at.as_json,
          "sleep_date" => user_sleep_logs.last.sleep_date.to_s,
          "sleep_at" => user_sleep_logs.last.sleep_at.as_json,
          "wake_at" => user_sleep_logs.last.wake_at.as_json,
          "duration_second" => user_sleep_logs.last.duration_second
        })

      expect(json["data"]["user_sleep_logs"].last)
        .to eq({
          "id" => user_sleep_logs.first.id,
          "created_at" => user_sleep_logs.first.created_at.as_json,
          "sleep_date" => user_sleep_logs.first.sleep_date.to_s,
          "sleep_at" => user_sleep_logs.first.sleep_at.as_json,
          "wake_at" => user_sleep_logs.first.wake_at.as_json,
          "duration_second" => user_sleep_logs.first.duration_second
        })
    end
  end

  context "with pagination and ordering params" do
    it "returns 200 and uses the given params for fetching user sleep logs" do
      get "/goodnight/api/v1/sleep_logs/me", params: { limit: 1, page: 2, order: "id asc" }, headers: headers

      expect(json["data"]["user_sleep_logs"].size).to eq(1)

      # match sleep logs order based on id desc
      returned_ids = json["data"]["user_sleep_logs"].map { |h| h["id"] }
      expect(returned_ids).to eq([ user_sleep_logs[1].id ])

      expect(json["data"]["user_sleep_logs"].first)
        .to eq({
          "id" => user_sleep_logs[1].id,
          "created_at" => user_sleep_logs[1].created_at.as_json,
          "sleep_date" => user_sleep_logs[1].sleep_date.to_s,
          "sleep_at" => user_sleep_logs[1].sleep_at.as_json,
          "wake_at" => user_sleep_logs[1].wake_at.as_json,
          "duration_second" => user_sleep_logs[1].duration_second
        })
    end
  end
end
