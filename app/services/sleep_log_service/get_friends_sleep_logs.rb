module SleepLogService
  class GetFriendsSleepLogs < BaseService
    DEFAULT_LIMIT = 20
    ALLOWED_ORDERS = [ "duration desc", "duration asc" ].freeze

    def initialize(user, params = {})
      @user = user
      @params = params.permit(:limit, :page, :min_sleep_date, :order)
    end

    def call
      validate
      execute_logic
      @result
    end

    private

    def validate
      raise Errors::Unauthorized if @user.blank?

      if @params[:order].presence && !ALLOWED_ORDERS.include?(@params[:order].to_s)
        raise Errors::InvalidOrdering
      end
    end

    def execute_logic
      order = (@params[:order].presence || "duration desc").to_s

      now = Time.current
      min_sleep_date = (now - 7.days).to_date
      if @params[:min_sleep_date].presence
        min_sleep_date = Time.zone.parse(@params[:min_sleep_date].to_s).to_date
      end

      page = (@params[:page].presence || 1).to_i
      page = 1 if page < 1

      limit = (@params[:limit].presence || DEFAULT_LIMIT).to_i
      limit = DEFAULT_LIMIT if limit <= 0

      offset = (page - 1) * limit

      sql = <<-SQL
        SELECT
          usl.id,
          u.id AS user_id,
          u.name AS user_name,
          usl.sleep_date,
          usl.sleep_at,
          usl.wake_at,
          usl.duration_second,
          (usl.duration_second / 3600.0)::float AS duration_hour
        FROM user_follows uf
        INNER JOIN users u ON u.id = uf.to_user_id
        INNER JOIN user_sleep_logs usl ON usl.user_id = u.id
        WHERE
          uf.from_user_id = :my_user_id
          AND usl.sleep_date >= :min_sleep_date
        ORDER BY
          CASE WHEN :order = 'duration desc' THEN usl.duration_second END DESC,
          CASE WHEN :order = 'duration asc' THEN usl.duration_second END ASC,
          usl.id DESC
        LIMIT :limit OFFSET :offset
      SQL

      friend_sleep_logs = UserSleepLog.find_by_sql(
        [
          sql,
          {
            my_user_id: @user.id,
            min_sleep_date: min_sleep_date,
            limit: limit,
            offset: offset,
            order: order
          }
        ]
      )

      @result = {
        friend_sleep_logs: friend_sleep_logs.as_json
      }
    end
  end
end
