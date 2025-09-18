require "rails_helper"

RSpec.describe SleepLogService::StartSleep do
  describe "#call" do
    subject(:call_service) { described_class.new(user).call }

    let(:user) { create(:user) }

    context "when user is nil" do
      let(:user) { nil }

      it "raises UNAUTHORIZED and does not create any user sleep log" do
        expect do
          described_class.new(user).call
        end
          .to raise_error(ConstErr::UNAUTHORIZED)
        .and not_change(UserSleepLog, :count)
      end
    end

    context "when the user call sleep for the second time" do
      it "raises MUST_WAKE_FIRST and does not create a new log" do
        described_class.new(user).call
        expect do
          described_class.new(user).call
        end
          .to raise_error(ConstErr::MUST_WAKE_FIRST)
          .and not_change(UserSleepLog, :count)
      end
    end

    context "when everything is valid" do
      it "creates a sleep log with the current time and returns it" do
        frozen_time = Time.current
        allow(Time).to receive(:current).and_return(frozen_time)

        expect do
          described_class.new(user).call
        end.to change(UserSleepLog, :count).by(1)

        sleep_log = UserSleepLog.order(:id).last
        expect(sleep_log.user).to eq(user)
        expect(sleep_log.sleep_at.to_i).to eq(frozen_time.to_i)
        expect(sleep_log.wake_at).to be_nil
      end
    end
  end
end
