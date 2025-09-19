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
      raise ConstErr::UNAUTHORIZED if @user.blank?

      raise ConstErr::MUST_WAKE_FIRST if UserSleepLog.where(user: @user, wake_at: nil).order(id: :desc).first.present?
    end

    def execute_logic
      now = Time.current

      user_sleep_log = UserSleepLog.create!(
        user: @user,
        sleep_at: now,
        sleep_date: now.to_date
      )

      @result = {
        id: user_sleep_log.id
      }
    end
  end
end
