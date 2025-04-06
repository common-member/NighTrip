require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/profile"
      expect(response).to have_http_status(302)
    end
  end
end
