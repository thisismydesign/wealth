# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  def self.ransackable_attributes(_auth_object = nil)
    ['email']
  end

  has_many :fundings, dependent: :restrict_with_error
  has_many :incomes, dependent: :restrict_with_error
  has_many :trades, dependent: :restrict_with_error
end
