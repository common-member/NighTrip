require 'rails_helper'

RSpec.describe "Users::OmniauthCallbacks", type: :request do
  describe "GET /users/auth/google_oauth2/callback" do
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456789",
        info: { email: "test@example.com", name: "Test User" }
      )
    end

    it "Google認証でログインが成功し、リダイレクトされること" do
      get user_google_oauth2_omniauth_callback_path
      expect(response).to have_http_status(302)
    end
  end
end
