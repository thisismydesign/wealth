# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminPolicy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }
  let(:admin) { build(:user, role: :admin) }

  permissions :index?, :show?, :create?, :new?, :update?, :edit?, :destroy? do
    it 'denies access to users' do
      expect(policy).not_to permit(user)
    end
  end

  permissions :index?, :show?, :create?, :new?, :update?, :edit? do
    it 'allows access to admins' do
      expect(policy).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'denies access to admins' do
      expect(policy).not_to permit(admin)
    end
  end

  describe AdminPolicy::Scope do
    subject(:policy_scope) { described_class.new(user, User).resolve }

    before { create(:user) }

    context 'when user is an admin' do
      let(:user) { build(:user, role: :admin) }

      it 'returns all users' do
        expect(policy_scope).to eq(User.all)
      end
    end

    context 'when user is not an admin' do
      let(:user) { build(:user) }

      it 'returns an empty relation' do
        expect(policy_scope).to be_empty
      end
    end
  end
end
