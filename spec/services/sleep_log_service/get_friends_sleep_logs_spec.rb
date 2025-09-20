# spec/services/sleep_log_service/get_friends_sleep_logs_spec.rb
require "rails_helper"

RSpec.describe SleepLogService::GetFriendsSleepLogs do
  include ActiveSupport::Testing::TimeHelpers

  let(:now) { Time.current }
  let!(:me) { User.create!(guid: SecureRandom.uuid, name: "Me") }
  let!(:friend_a) { User.create!(guid: SecureRandom.uuid, name: "Alice") }
  let!(:friend_b) { User.create!(guid: SecureRandom.uuid, name: "Bob") }
  let!(:stranger) { User.create!(guid: SecureRandom.uuid, name: "Stranger") }

  before do
    UserFollow.create!(from_user_id: me.id, to_user_id: friend_a.id)
    UserFollow.create!(from_user_id: me.id, to_user_id: friend_b.id)
  end

  describe "#call" do
    context "authorization" do
      it "raises UNAUTHORIZED when user is blank" do
        expect do
          described_class.new(nil, ActionController::Parameters.new({})).call
        end.to raise_error(Errors::Unauthorized)
      end
    end

    context "default behavior (last 7 days, ordered by duration desc)" do
      before do
        now = Time.current

        # within last 7 days (included)
        UserSleepLog.create!(
          user_id: friend_a.id,
          sleep_date: (now - 1.day).to_date,
          sleep_at: now - 1.day - 8.hours,
          wake_at: now - 1.day - 2.hours,
          duration_second: (8.hours - 2.hours).to_i # 6 hours
        )
        UserSleepLog.create!(
          user_id: friend_b.id,
          sleep_date: (now - 7.day).to_date,
          sleep_at: now - 7.day - 9.hours,
          wake_at: now - 7.day - 7.hours,
          duration_second: (9.hours - 7.hours).to_i # 2 hours
        )

        # older than 7 days (excluded by default)
        UserSleepLog.create!(
          user_id: friend_a.id,
          sleep_date: (now - 15.day).to_date,
          sleep_at: now - 15.day - 9.hours,
          wake_at: now - 15.day - 1.hours,
          duration_second: (9.hours - 1.hours).to_i
        )

        # stranger's recent log (should be excluded because not followed)
        UserSleepLog.create!(
          user_id: stranger.id,
          sleep_date: (now - 2.day).to_date,
          sleep_at: now - 2.day - 9.hours,
          wake_at: now - 2.day - 7.hours,
          duration_second: (9.hours - 7.hours).to_i
        )
      end

      it "returns only followed users logs in last 7 days, sorted by longest duration" do
        service = described_class.new(me, ActionController::Parameters.new({}))
        service.call
        result = service.result

        logs = result[:friend_sleep_logs]
        expect(logs).to be_an(Array)
        # only two logs within window from followed users
        expect(logs.size).to eq(2)

        # order by duration_second desc
        expect(logs.map { |h| [ h["user_name"], h["duration_second"] ] })
          .to eq([ [ friend_a.name, (8.hours - 2.hours).to_i ], [ friend_b.name, (9.hours - 7.hours).to_i ] ])
      end

      it "matches with the expected data structure" do
        service = described_class.new(
          me, ActionController::Parameters.new({ limit: 1, page: 1 })
        )
        service.call
        result = service.result

        user_sleep_log = friend_a.user_sleep_logs.find_by([ "sleep_date >= ?", (now - 7.days).to_date ])

        logs = result[:friend_sleep_logs]
        expect(logs).to eq(
          [
            {
              "id" => user_sleep_log.id,
              "user_id" => friend_a.id,
              "user_name" => friend_a.name,
              "sleep_date" => user_sleep_log.sleep_date.as_json,
              "sleep_at" => user_sleep_log.sleep_at.as_json,
              "wake_at" => user_sleep_log.wake_at.as_json,
              "duration_second" => user_sleep_log.duration_second,
              "duration_hour" => user_sleep_log.duration_second / 3600.0
            }
          ]
        )
      end
    end
  end
end
