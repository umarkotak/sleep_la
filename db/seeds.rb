User.find_or_create_by!(guid: "e9e06402-757a-4649-9f5c-2961185738a6", name: "Umar Ramadhana")
User.find_or_create_by!(guid: "0b5b8bb9-d38f-4771-9c86-fbff54d901d5", name: "Jhone Doe")
User.find_or_create_by!(guid: "7190a501-3280-45a3-80b1-eaf9d6ca9ed9", name: "Daniel Smith")
User.find_or_create_by!(guid: "24ad92a2-397b-4d46-a1c3-af68eb40bab2", name: "Beth")

user1 = User.find_by(guid: "e9e06402-757a-4649-9f5c-2961185738a6")
user1SleepLog1Time = Time.zone.parse("2025-09-01 19:00:00")
UserSleepLog.create!(
  user: user1, sleep_date: user1SleepLog1Time.to_date, sleep_at: user1SleepLog1Time, wake_at: user1SleepLog1Time+8.hours,
)
user1SleepLog2Time = Time.zone.parse("2025-09-02 19:00:00")
UserSleepLog.create!(
  user: user1, sleep_date: user1SleepLog2Time.to_date, sleep_at: user1SleepLog2Time, wake_at: user1SleepLog2Time+7.hours,
)
user1SleepLog3Time = Time.zone.parse("2025-09-03 19:00:00")
UserSleepLog.create!(
  user: user1, sleep_date: user1SleepLog3Time.to_date, sleep_at: user1SleepLog3Time, wake_at: user1SleepLog3Time+6.hours,
)

user2 = User.find_by(guid: "0b5b8bb9-d38f-4771-9c86-fbff54d901d5")
user2SleepLog1Time = Time.zone.parse("2025-09-01 19:00:00")
UserSleepLog.create!(
  user: user2, sleep_date: user2SleepLog1Time.to_date, sleep_at: user2SleepLog1Time, wake_at: user2SleepLog1Time+5.hours,
)
user2SleepLog2Time = Time.zone.parse("2025-09-02 19:00:00")
UserSleepLog.create!(
  user: user2, sleep_date: user2SleepLog2Time.to_date, sleep_at: user2SleepLog2Time, wake_at: user2SleepLog2Time+7.hours,
)
user2SleepLog3Time = Time.zone.parse("2025-09-03 19:00:00")
UserSleepLog.create!(
  user: user2, sleep_date: user2SleepLog3Time.to_date, sleep_at: user2SleepLog3Time, wake_at: user2SleepLog3Time+9.hours,
)
