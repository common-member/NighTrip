require 'rails_helper'

RSpec.describe "Diagnoses", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/diagnosis"
      expect(response).to have_http_status(302)
    end
  end

  describe "GET /result" do
    it "returns http success" do
      get "/diagnosis/result"
      expect(response).to have_http_status(302)
    end
  end
end
