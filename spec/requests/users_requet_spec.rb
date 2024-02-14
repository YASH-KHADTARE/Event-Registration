# spec/requests/user_request_spec.rb

require 'rails_helper'


RSpec.describe "Users", type: :request do
  describe "POST /users" do
    it "creates a new user" do
      post "/users", params: { user: { username: "test_user", email: "test@example.com", password: "Password123", full_name: "Test User" } }
      expect(response).to have_http_status(200)
      expect(json_response["user"]["username"]).to eq("test_user")
    end
  end

  describe "GET /users/:id" do
    let(:user) { create(:user) }
    let(:auth_headers) { { "Authorization" => "Bearer #{token}" } }

    it "returns a specific user" do
      get "/users/#{user.id}", headers: authenticated_header(user)
      expect(response).to have_http_status(200)
      expect(json_response["user"]["username"]).to eq(user.username)
    end
  end
end
