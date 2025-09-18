module SleepLogService
  class StartSleep < BaseService
    def initialize(user)
      @user = user
    end

    def call
      validate
      execute_logic
      @result
    end

    private

    def validate
      raise ConstErr::MISSING_USER if @user.blank?

      raise ConstErr::MUST_WAKE_FIRST if UserSleepLog.find_by(user: @user, wake_at: nil).present?
    end

    def execute_logic
      user_sleep_log = UserSleepLog.create!(user: @user, sleep_at: Time.current)

      @result = user_sleep_log
    end
  end
end
