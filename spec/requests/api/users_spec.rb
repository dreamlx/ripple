require 'rails_helper'

RSpec.describe "users" do
  describe "PATCH #update" do
    it "update password" do
      user = create(:user)
      password_digest = user.password_digest
      token = user.authentication_token
      valid_header  = {
          authorization: ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token},nickname=#{user.nickname}")
        }
      patch "/api/users/update_password", params: { password: "new_password"}, headers: valid_header
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      user.reload
      expect(user.password_digest).not_to eq password_digest
      expect(user.authentication_token).not_to eq token
    end
  end
end
