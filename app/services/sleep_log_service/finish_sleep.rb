module SleepLogService
  class FinishSleep < BaseService
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
      raise ConstErr::UNAUTHORIZED if @user.blank?
    end

    def execute_logic
      user_sleep_log = UserSleepLog.where(user: @user, wake_at: nil).order(id: :desc).first

      raise ConstErr::MUST_SLEEP_FIRST if user_sleep_log.blank?

      now = Time.current

      user_sleep_log.update!(
        wake_at: now,
        duration_second: now.to_i - user_sleep_log.sleep_at.to_i
      )

      @result = {
        id: user_sleep_log.id
      }
    end
  end
end
