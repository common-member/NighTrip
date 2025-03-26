require 'rails_helper'

RSpec.describe "Tops", type: :request do
  describe "GET /" do
    context '未ログイン時' do
      it "トップページに正常にアクセスできること" do
        get root_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ログイン時' do
      let(:user) { create(:user, email: "user_#{SecureRandom.hex(4)}@example.com") }

      it 'spots#index にリダイレクトされること' do
        sign_in user

        get root_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
