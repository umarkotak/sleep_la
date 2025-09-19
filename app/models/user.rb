class User < ApplicationRecord
  before_validation :assign_guid, on: :create

  validates :name, presence: true
  validates :guid, presence: true

  has_many :user_sleep_logs
  has_many :user_follows, foreign_key: :from_user_id, class_name: "UserFollow"

  private

  def assign_guid
    self.guid ||= SecureRandom.uuid
  end
end
