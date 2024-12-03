# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email(domain: 'test.com') }
    password { 'asdasdasd!!' }
    password_confirmation { 'asdasdasd!!' }
  end
end
