# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.name }
    ticker { Faker::Currency.code }
  end
end
