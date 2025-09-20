require 'rails_helper'

RSpec.describe UserService::Unfollow do
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

      it 'raises MISSING_USER_GUID_TO_UNFOLLOW' do
        expect do
          described_class.new(current_user, params).call
        end
          .to raise_error(Errors::MissingUserGuidToUnfollow)
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

    context 'when attempting to unfollow self' do
      let(:target_user) { current_user }

      it 'raises CANNOT_UNFOLLOW_SELF' do
        expect do
          described_class.new(current_user, params).call
        end
          .to raise_error(Errors::CannotUnfollowSelf)
      end
    end

    context 'when a follow exists' do
      it 'deletes the follow' do
        UserService::Follow.new(current_user, params).call

        expect do
          described_class.new(current_user, params).call
        end
          .to change(UserFollow, :count).by(-1)

        expect(
          UserFollow.find_by(from_user_id: current_user.id, to_user_id: target_user.id)
        ).to be_nil
      end
    end

    context 'when a follow does not exist' do
      it 'does not change count' do
        expect do
          described_class.new(current_user, params).call
        end
          .not_to change(UserFollow, :count)
      end
    end
  end
end
