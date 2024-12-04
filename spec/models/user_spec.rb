# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to define_enum_for(:role).with_values(%i[user admin]) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:fundings).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:incomes).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:trades).dependent(:restrict_with_error) }
  end
end
