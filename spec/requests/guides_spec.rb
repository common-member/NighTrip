# spec/requests/guides_spec.rb

require 'rails_helper'

RSpec.describe "Guides", type: :request do
  describe "GET /guide" do
    it "returns http success" do
      get "/guide"
      expect(response).to have_http_status(200)
    end
  end
end
