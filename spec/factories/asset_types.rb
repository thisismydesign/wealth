# frozen_string_literal: true

FactoryBot.define do
  factory :asset_type do
    name { Faker::Lorem.unique.word }
  end
end
