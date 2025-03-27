require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/sign_in" do
    it "ログインページの表示に成功する" do
      get new_user_session_path
      expect(response).to have_http_status(200)
      expect(response.body).to include("ログイン")
    end
  end

  describe "POST /users/sign_in" do
    let(:user) { create(:user) }

    it "正しい資格情報でログインできる" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: 'password'
        }
      }
      expect(response).to have_http_status(303)
    end

    it "不正な資格情報ではログインできない" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "wrongpassword"
        }
      }
      expect(response).to have_http_status(422)
      expect(response.body).to include("ログイン")
    end
  end

  describe "DELETE /users/sign_out" do
    let(:user) { create(:user, password: "password") }

    it "ログアウトできる" do
      sign_in user
      delete destroy_user_session_path
      expect(response).to redirect_to(root_path)
    end
  end
end
