module SleepLogService
  class GetMySleepLogs < BaseService
    DEFAULT_LIMIT = 20
    ALLOWED_ORDERS = [ "id desc", "id asc" ].freeze

    def initialize(user, params = {})
      @user = user
      @params = params.permit(:limit, :page, :order)
    end

    def call
      validate
      execute_logic
      @result
    end

    private

    def validate
      raise ConstErr::UNAUTHORIZED if @user.blank?

      if @params[:order].presence
        raise ConstErr::INVALID_ORDERING if !ALLOWED_ORDERS.include?(@params[:order].to_s)
      end
    end

    def execute_logic
      order = (@params[:order].presence || "id desc").to_s

      page = (@params[:page].presence || 1).to_i
      page = 1 if page < 1

      limit = (@params[:limit].presence || DEFAULT_LIMIT).to_i
      limit = DEFAULT_LIMIT if limit <= 0

      offset = (page - 1) * limit

      user_sleep_logs = @user.user_sleep_logs
                             .select(
                              :id, :created_at, :sleep_date, :sleep_at, :wake_at, :duration_second
                             )
                             .order(order)
                             .limit(limit)
                             .offset(offset)

      @result = {
        user_sleep_logs: user_sleep_logs.as_json
      }
    end
  end
end
