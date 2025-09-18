# frozen_string_literal: true

FactoryBot.define do
  factory :user_sleep_log do
    association :user

    sleep_at { 5.hours.ago }
    wake_at  { nil }
    sleep_date { 5.hours.ago.to_date }
    duration_second { nil }
  end
end
