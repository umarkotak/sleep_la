require "rails_helper"

RSpec.describe SleepLogService::GetMySleepLogs do
  describe "#call" do
    let!(:user) { create(:user) }
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
      it "raises UNAUTHORIZED" do
        expect do
          described_class.new(nil, ActionController::Parameters.new({})).call
        end
          .to raise_error(Errors::Unauthorized)
      end
    end

    context "when ordering is invalid" do
      it "raises INVALID_ORDERING" do
        expect do
          described_class.new(user, ActionController::Parameters.new({
            order: "' OR 1 = 1"
          })).call
        end
          .to raise_error(Errors::InvalidOrdering)
      end
    end

    context "with defaults" do
      it "uses default default params for fetching user sleep logs" do
        service = described_class.new(user, ActionController::Parameters.new({}))
        service.call
        result = service.result

        expect(result[:user_sleep_logs].size).to eq(user_sleep_logs.size)

        # match sleep logs order based on id desc
        returned_ids = result[:user_sleep_logs].map { |h| h["id"] }
        expect(returned_ids).to eq(UserSleepLog.where(user: user).order("id desc").pluck(:id))

        expect(result[:user_sleep_logs].first)
          .to eq({
            "id" => user_sleep_logs.last.id,
            "created_at" => user_sleep_logs.last.created_at.as_json,
            "sleep_date" => user_sleep_logs.last.sleep_date.to_s,
            "sleep_at" => user_sleep_logs.last.sleep_at.as_json,
            "wake_at" => user_sleep_logs.last.wake_at.as_json,
            "duration_second" => user_sleep_logs.last.duration_second
          })

        expect(result[:user_sleep_logs].last)
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

    context "with pagination and order" do
      it "uses given custom params for fetching user sleep logs" do
        service = described_class.new(user, ActionController::Parameters.new({
          limit: 1, page: 2, order: "id asc"
        }))
        service.call
        result = service.result

        expect(result[:user_sleep_logs].size).to eq(1)

        # match sleep logs order based on id desc
        returned_ids = result[:user_sleep_logs].map { |h| h["id"] }
        expect(returned_ids).to eq([ user_sleep_logs[1].id ])

        expect(result[:user_sleep_logs].first)
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
end
