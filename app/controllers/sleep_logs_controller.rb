class SleepLogsController < ApplicationController
  def start_sleep
    authenticate_user
    service = SleepLogService::StartSleep.new(@user)
    service.call
    render_response(data: service.result)
  end

  def finish_sleep
    authenticate_user
    service = SleepLogService::FinishSleep.new(@user)
    service.call
    render_response(data: service.result)
  end

  def get_my_sleep_logs
    authenticate_user
    service = SleepLogService::GetMySleepLogs.new(@user, params)
    service.call
    render_response(data: service.result)
  end

  def get_friends_sleep_logs
  end
end
