require 'rails_helper'

RSpec.describe "POST /goodnight/api/v1/user/:user_guid/follow", type: :request do
  let(:current_user) { create(:user) }

  let(:auth_token) do
    AuthService::Login.new(ActionController::Parameters.new(user_guid: current_user.guid)).call
  end

  let(:headers) { {
    Authorization: auth_token["token"]
  } }

  let(:target_user) { create(:user) }
  let(:params) { ActionController::Parameters.new(user_guid: target_user.guid) }

  context "when header authorization is empty" do
    it 'return 401 UNAUTHORIZED' do
      post "/goodnight/api/v1/user/#{target_user.guid}/follow", headers: {}

      expect(response).to have_http_status(401)
    end
  end

  context 'when using unregistered user guid' do
    it 'returns 404 user not found' do
      post "/goodnight/api/v1/user/#{SecureRandom.uuid}/follow", headers: headers

      expect(response).to have_http_status(404)
      expect(json["error"]).to eq("user not found")
    end
  end

  context 'when attempting to follow self' do
    let(:target_user) { current_user }

    it 'returns 400 cannot follow self' do
      post "/goodnight/api/v1/user/#{current_user.guid}/follow", headers: headers

      expect(response).to have_http_status(400)
      expect(json["error"]).to eq("cannot follow self")
    end
  end

  context 'when following a new user' do
    it 'returns 200 and creates a UserFollow' do
      expect do
        post "/goodnight/api/v1/user/#{target_user.guid}/follow", headers: headers
      end
        .to change(UserFollow, :count).by(1)

      follow = UserFollow.last
      expect(follow.from_user_id).to eq(current_user.id)
      expect(follow.to_user_id).to eq(target_user.id)
    end
  end

  context 'when already following the target user then follow it again' do
    it 'returns 200 and does not create a duplicate record' do
      post "/goodnight/api/v1/user/#{target_user.guid}/follow", headers: headers

      expect do
        post "/goodnight/api/v1/user/#{target_user.guid}/follow", headers: headers
      end.not_to change(UserFollow, :count)

      existing = UserFollow.find_by(from_user_id: current_user.id, to_user_id: target_user.id)
      expect(existing).to be_present
    end
  end
end
