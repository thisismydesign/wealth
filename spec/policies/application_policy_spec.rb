# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }

  permissions :index?, :show?, :create?, :new?, :update?, :edit?, :destroy? do
    it 'denies access to users' do
      expect(policy).not_to permit(user)
    end
  end

  describe ApplicationPolicy::Scope do
    subject(:policy_scope) { described_class.new(user, User).resolve }

    it 'raises NoMethodError' do
      expect { policy_scope }.to raise_error(NoMethodError, /You must define #resolve in/)
    end
  end
end
