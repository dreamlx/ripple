require 'rails_helper'

RSpec.describe "sessions" do
  describe "POST #create" do
    it "login with nickname and password" do
      user = create(:user)
      post "/api/login", params: {nickname: user.nickname, password: user.password}
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq user.name
      expect(json["nickname"]).to eq user.nickname
      expect(json["token"]).to eq user.authentication_token
      expect(json["token"]).not_to be_nil
    end

    it "failed to login with wrong password" do
      user = create(:user)
      post "/api/login", params: {nickname: user.nickname, password: "wrong password"}
      expect(response).not_to be_successful
      expect(response).to have_http_status(401)
    end
  end
end