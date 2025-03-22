# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPolicy do
  subject(:policy) { described_class }

  let(:user) { build(:user) }
  let(:admin) { build(:user, role: :admin) }

  permissions :create?, :new?, :index? do
    it 'allows access to users' do
      expect(policy).to permit(user)
    end

    it 'allows access to admins' do
      expect(policy).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'denies access to users' do
      expect(policy).not_to permit(user)
    end

    it 'denies access to admins' do
      expect(policy).not_to permit(admin)
    end
  end

  permissions :update?, :edit? do
    context 'when asset is global' do
      let(:asset) { build(:asset, user: nil) }

      it 'denies access to users' do
        expect(policy).not_to permit(user, asset)
      end

      it 'allows access to admins' do
        expect(policy).to permit(admin, asset)
      end
    end

    context 'when asset belongs to user' do
      let(:asset) { build(:asset, user:) }

      it 'allows access to users' do
        expect(policy).to permit(user, asset)
      end

      it 'denies access to admins' do
        expect(policy).not_to permit(admin, asset)
      end
    end

    context 'when asset belongs to other user' do
      let(:asset) { build(:asset, user: build(:user)) }

      it 'denies access to users' do
        expect(policy).not_to permit(user, asset)
      end

      it 'denies access to admins' do
        expect(policy).not_to permit(admin, asset)
      end
    end
  end

  permissions :show? do
    context 'when asset is global' do
      let(:asset) { build(:asset, user: nil) }

      it 'allows access to users' do
        expect(policy).to permit(user, asset)
      end

      it 'allows access to admins' do
        expect(policy).to permit(admin, asset)
      end
    end

    context 'when asset belongs to user' do
      let(:asset) { build(:asset, user:) }

      it 'allows access to users' do
        expect(policy).to permit(user, asset)
      end

      it 'allows access to admins' do
        expect(policy).to permit(admin, asset)
      end
    end

    context 'when asset belongs to other user' do
      let(:asset) { build(:asset, user: build(:user)) }

      it 'denies access to users' do
        expect(policy).not_to permit(user, asset)
      end

      it 'allows access to admins' do
        expect(policy).to permit(admin, asset)
      end
    end
  end

  describe AssetPolicy::Scope do
    subject(:policy_scope) { described_class.new(user, Asset).resolve }

    let!(:entity) { create(:asset, user: create(:user)) }

    context 'when user is an admin' do
      let(:user) { build(:user, role: :admin) }

      it 'returns all entities' do
        expect(policy_scope).to include(entity)
      end
    end

    context 'when user is not an admin' do
      let(:user) { build(:user) }

      it 'returns an empty relation' do
        expect(policy_scope).to be_empty
      end

      context 'when entity belongs to user' do
        let(:entity) { create(:asset, user:) }

        it 'returns the entity' do
          expect(policy_scope).to include(entity)
        end
      end
    end
  end
end
