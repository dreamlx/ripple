require 'rails_helper'

RSpec.describe "projects" do
  describe "GET #index" do
    it "get all projects" do
      project = create(:project)
      get "/api/projects"
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json.count).to eq 1
      expect(json.first["id"]).to eq project.id
      expect(json.first["name"]).to eq project.name
    end
  end
end