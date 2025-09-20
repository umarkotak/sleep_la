require 'rails_helper'

RSpec.describe "POST /goodnight/api/v1/user/:user_guid/unfollow", type: :request do
  let(:current_user) { create(:user) }

  let(:auth_token) do
    AuthService::Login.new(ActionController::Parameters.new(user_guid: current_user.guid)).call
  end

  let(:headers) { {
    Authorization: auth_token["token"]
  } }

  let(:target_user) { create(:user) }

  context "when header authorization is empty" do
    it 'return 401 UNAUTHORIZED' do
      post "/goodnight/api/v1/user/#{target_user.guid}/unfollow", headers: {}

      expect(response).to have_http_status(401)
    end
  end

  context 'when using unregistered user guid' do
    it 'returns 404 user not found' do
      post "/goodnight/api/v1/user/#{SecureRandom.uuid}/unfollow", headers: headers

      expect(response).to have_http_status(404)
      expect(json["error"]).to eq("user not found")
    end
  end

  context 'when attempting to unfollow self' do
    let(:target_user) { current_user }

    it 'returns 400 cannot unfollow self' do
      post "/goodnight/api/v1/user/#{current_user.guid}/unfollow", headers: headers

      expect(response).to have_http_status(400)
      expect(json["error"]).to eq("cannot unfollow self")
    end
  end

  context 'when a follow exists' do
    it 'deletes the follow' do
      expect do
        post "/goodnight/api/v1/user/#{target_user.guid}/follow", headers: headers
      end
        .to change(UserFollow, :count).by(1)
      expect(response).to have_http_status(200)

      expect do
        post "/goodnight/api/v1/user/#{target_user.guid}/unfollow", headers: headers
      end
        .to change(UserFollow, :count).by(-1)
      expect(response).to have_http_status(200)

      expect(
        UserFollow.find_by(from_user_id: current_user.id, to_user_id: target_user.id)
      ).to be_nil
    end
  end

  context 'when a follow does not exist' do
    it 'does not change count' do
      expect do
        post "/goodnight/api/v1/user/#{target_user.guid}/unfollow", headers: headers
      end
        .not_to change(UserFollow, :count)
    end
  end
end
