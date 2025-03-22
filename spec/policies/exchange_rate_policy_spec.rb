# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRatePolicy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }
  let(:admin) { build(:user, role: :admin) }

  permissions :create?, :new?, :update?, :edit?, :destroy? do
    it 'denies access to users' do
      expect(policy).not_to permit(user)
    end

    it 'denies access to admins' do
      expect(policy).not_to permit(admin)
    end
  end

  permissions :index? do
    it 'allows access to users' do
      expect(policy).to permit(user)
    end

    it 'allows access to admins' do
      expect(policy).to permit(admin)
    end
  end

  permissions :show? do
    let(:exchange_rate) { build_stubbed(:exchange_rate) }
    let(:user) { build_stubbed(:user) }

    it 'allows access to admins' do
      expect(policy).to permit(admin)
    end

    it 'allows access to users' do
      expect(policy).to permit(user, exchange_rate)
    end

    context 'when user does not have access to from asset' do
      let(:exchange_rate) { build_stubbed(:exchange_rate, from: build_stubbed(:asset, user: build_stubbed(:user))) }

      it 'denies access' do
        expect(policy).not_to permit(user, exchange_rate)
      end
    end

    context 'when user does not have access to to asset' do
      let(:exchange_rate) { build_stubbed(:exchange_rate, to: build_stubbed(:asset, user: build_stubbed(:user))) }

      it 'denies access' do
        expect(policy).not_to permit(user, exchange_rate)
      end
    end
  end

  describe ExchangeRatePolicy::Scope do
    subject(:policy_scope) { described_class.new(user, ExchangeRate).resolve }

    let!(:entity) { create(:exchange_rate) }

    context 'when user is an admin' do
      let(:user) { build(:user, role: :admin) }

      it 'returns all entities' do
        expect(policy_scope).to include(entity)
      end
    end

    context 'when user is not an admin' do
      let(:user) { build(:user) }

      it 'allows access to users' do
        expect(policy_scope).to include(entity)
      end

      context 'when user does not have access to from asset' do
        let(:exchange_rate) { create(:exchange_rate, from: create(:asset, user: create(:user))) }

        it 'does not include the entity' do
          expect(policy_scope).not_to include(exchange_rate)
        end
      end

      context 'when user does not have access to to asset' do
        let(:exchange_rate) { create(:exchange_rate, to: create(:asset, user: create(:user))) }

        it 'does not include the entity' do
          expect(policy_scope).not_to include(exchange_rate)
        end
      end
    end
  end
end
