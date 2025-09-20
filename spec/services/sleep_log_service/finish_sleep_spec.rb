require "rails_helper"

RSpec.describe SleepLogService::FinishSleep do
  describe "#call" do
    let(:user) { create(:user) }

    context "when user is nil" do
      let!(:user_sleep_log) { create(:user_sleep_log, user: user) }

      it "raises UNAUTHORIZED and does not update user sleep log" do
        expect do
          described_class.new(nil).call
        end
          .to raise_error(Errors::Unauthorized)

        user_sleep_log.reload
        expect(user_sleep_log.wake_at).to be_nil
      end
    end

    context "when there is no open sleep log (sleep log with wake_at is nil)" do
      let!(:user_sleep_log) { create(:user_sleep_log,
        user: user,
        sleep_at: 1.day.ago,
        wake_at: 12.hours.ago,
        duration_second: 12.hours.to_i)
      }

      it "raises MUST_SLEEP_FIRST and do nothing" do
        expect do
          described_class.new(user).call
        end
          .to raise_error(Errors::MustSleepFirst)
          .and not_change(UserSleepLog, :count)
      end
    end
  end
end
