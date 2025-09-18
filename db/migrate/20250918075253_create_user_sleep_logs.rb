class CreateUserSleepLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :user_sleep_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.date :sleep_date
      t.datetime :sleep_at
      t.datetime :wake_at
      t.bigint :duration_second

      t.timestamps
    end
    add_index :user_sleep_logs, :sleep_date
  end
end
