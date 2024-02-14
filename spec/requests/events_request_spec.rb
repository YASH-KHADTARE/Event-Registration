# spec/requests/events_request_spec.rb

require 'rails_helper'

RSpec.describe "Events", type: :request do
  
  describe "GET /events/:id" do
    let(:event) { create(:event) }

    it "returns a specific event" do
      get "/events/#{event.id}"
      expect(response).to have_http_status(200)
      expect(json_response["id"]).to eq(event.id)
    end
  end

  describe "POST /events" do
    let(:admin_user) { create(:user, role: "admin") }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)
    end

    it "creates a new event for admin user" do
      post "/events", params: { event: attributes_for(:event) }
      expect(response).to have_http_status(201)
      expect(Event.count).to eq(1)
    end
  end

 
end
