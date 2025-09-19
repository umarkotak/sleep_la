class User < ApplicationRecord
  before_validation :assign_guid, on: :create

  validates :name, presence: true
  validates :guid, presence: true

  has_many :user_sleep_logs

  private

  def assign_guid
    self.guid ||= SecureRandom.uuid
  end
end
