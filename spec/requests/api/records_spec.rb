require 'rails_helper'

RSpec.describe "records" do
  describe "GET #records_with_month" do
    it "get list_with_month" do
      user = create(:user)
      valid_header  = {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token},nickname=#{user.nickname}")
      }
      project = create(:project)
      record = create(:record, user_id: user.id, date: Date.today, project_id: project.id, hour: 4, remark: "remark")

      get "/api/records/list_with_month", params: {month: Date.today.strftime("%Y%M")}, headers: valid_header
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["list"]

      expect(json.count).to eq 1
      expect(json.first["date"]).to eq record.date.to_s
      expect(json.first["records"].first["name"]).to eq project.name
      expect(json.first["records"].first["hour"]).to eq 4
      expect(json.first["records"].first["remark"]).to eq "remark"
    end

    it "failed to get list_with_month: wrong month" do
      user = create(:user)
      valid_header  = {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token},nickname=#{user.nickname}")
      }
      project = create(:project)
      record = create(:record, user_id: user.id, date: Date.today, project_id: project.id)

      get "/api/records/list_with_month", params: {month: Date.today.strftime("%Y%M").succ}, headers: valid_header
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["list"]

      expect(json.count).to eq 0
    end

    it "get list_with_month without month" do
      user = create(:user)
      valid_header  = {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token},nickname=#{user.nickname}")
      }
      project = create(:project)
      record = create(:record, user_id: user.id, date: Date.today, project_id: project.id)

      get "/api/records/list_with_month", headers: valid_header
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)["list"]

      expect(json.count).to eq 1
      expect(json.first["date"]).to eq record.date.to_s
      expect(json.first["records"].first["name"]).to eq project.name
    end
  end

  describe "POST #create" do
    it "add a record" do
      Record.delete_all
      user = create(:user)
      valid_header  = {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token},nickname=#{user.nickname}")
      }

      project = create(:project)
      post "/api/records", params: {records: {"0" => {project_id: project.id, hour: 6, remark: "remark"}}, date: Date.today}, headers: valid_header
      expect(response).to be_successful
      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(Record.count).to eq 1
      record = Record.first
      expect(record.project_id).to eq project.id
      expect(record.user_id).to eq user.id
    end

    it "failed to add record if project_ids is empty" do
      Record.delete_all
      user = create(:user)
      valid_header  = {
        authorization: ActionController::HttpAuthentication::Token.encode_credentials("#{user.authentication_token},nickname=#{user.nickname}")
      }

      post "/api/records", params: {date: Date.today}, headers: valid_header
      expect(response).not_to be_successful
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq "项目id为空"
    end
  end
end