User.find_or_create_by!(guid: "e9e06402-757a-4649-9f5c-2961185738a6", name: "Umar Ramadhana")
User.find_or_create_by!(guid: "0b5b8bb9-d38f-4771-9c86-fbff54d901d5", name: "Jhone Doe")
User.find_or_create_by!(guid: "7190a501-3280-45a3-80b1-eaf9d6ca9ed9", name: "Daniel Smith")
User.find_or_create_by!(guid: "24ad92a2-397b-4d46-a1c3-af68eb40bab2", name: "Beth")

user1 = User.find_by(guid: "e9e06402-757a-4649-9f5c-2961185738a6")
user1SleepLog1Time = 6.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user1, sleep_date: user1SleepLog1Time.to_date, sleep_at: user1SleepLog1Time, wake_at: user1SleepLog1Time+8.hours, duration_second: 8.hours.to_i,
)
user1SleepLog2Time = 5.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user1, sleep_date: user1SleepLog2Time.to_date, sleep_at: user1SleepLog2Time, wake_at: user1SleepLog2Time+7.hours, duration_second: 7.hours.to_i,
)
user1SleepLog3Time = 4.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user1, sleep_date: user1SleepLog3Time.to_date, sleep_at: user1SleepLog3Time, wake_at: user1SleepLog3Time+6.hours, duration_second: 6.hours.to_i,
)

user2 = User.find_by(guid: "0b5b8bb9-d38f-4771-9c86-fbff54d901d5")
user2SleepLog1Time = 6.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user2, sleep_date: user2SleepLog1Time.to_date, sleep_at: user2SleepLog1Time, wake_at: user2SleepLog1Time+5.hours, duration_second: 5.hours.to_i,
)
user2SleepLog2Time = 4.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user2, sleep_date: user2SleepLog2Time.to_date, sleep_at: user2SleepLog2Time, wake_at: user2SleepLog2Time+7.hours, duration_second: 7.hours.to_i,
)
user2SleepLog3Time = 2.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user2, sleep_date: user2SleepLog3Time.to_date, sleep_at: user2SleepLog3Time, wake_at: user2SleepLog3Time+9.hours, duration_second: 9.hours.to_i,
)

user3 = User.find_by(guid: "7190a501-3280-45a3-80b1-eaf9d6ca9ed9")
user3SleepLog1Time = 3.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user3, sleep_date: user3SleepLog1Time.to_date, sleep_at: user3SleepLog1Time, wake_at: user3SleepLog1Time+10.hours, duration_second: 10.hours.to_i,
)
user3SleepLog2Time = 2.days.ago.change(hour: 19, min: 0, sec: 0)
UserSleepLog.create!(
  user: user3, sleep_date: user3SleepLog2Time.to_date, sleep_at: user3SleepLog2Time, wake_at: user3SleepLog2Time+1.hours, duration_second: 1.hours.to_i,
)
