# spec/services/user_service/follow_spec.rb
require 'rails_helper'

RSpec.describe UserService::Follow do
  describe '#call' do
    let(:current_user) { create(:user) }
    let(:target_user) { create(:user) }
    let(:params) { ActionController::Parameters.new(user_guid: target_user.guid) }

    context 'when user is not signed in' do
      let(:current_user) { nil }

      it 'raises UNAUTHORIZED' do
        expect do
          described_class.new(current_user, params).call
        end
          .to raise_error(Errors::Unauthorized)
      end
    end

    context 'when user_guid is missing' do
      let(:params) { ActionController::Parameters.new({}) }

      it 'raises MISSING_USER_GUID_TO_FOLLOW' do
        expect do
          described_class.new(current_user, params).call
        end
          .to raise_error(Errors::MissingUserGuidToFollow)
      end
    end

    context 'when target user cannot be found' do
      let(:params) { ActionController::Parameters.new(user_guid: SecureRandom.uuid) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          described_class.new(current_user, params).call
        end
          .to raise_error(Errors::UserNotFound)
      end
    end

    context 'when attempting to follow self' do
      let(:target_user) { current_user }

      it 'raises CANNOT_FOLLOW_SELF' do
        expect do
          described_class.new(current_user, params).call
        end
          .to raise_error(Errors::CannotFollowSelf)
      end
    end

    context 'when following a new user' do
      it 'creates a UserFollow' do
        expect do
          described_class.new(current_user, params).call
        end
          .to change(UserFollow, :count).by(1)

        follow = UserFollow.last
        expect(follow.from_user_id).to eq(current_user.id)
        expect(follow.to_user_id).to eq(target_user.id)
      end
    end

    context 'when already following the user (idempotent)' do
      it 'does not create a duplicate record' do
        described_class.new(current_user, params).call

        expect do
          described_class.new(current_user, params).call
        end.not_to change(UserFollow, :count)

        existing = UserFollow.find_by(from_user_id: current_user.id, to_user_id: target_user.id)
        expect(existing).to be_present
      end
    end
  end
end
