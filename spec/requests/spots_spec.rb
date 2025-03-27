require 'rails_helper'

RSpec.describe "Spots", type: :request do
  let(:user) { create(:user) }
  let(:prefecture) { create(:prefecture) }
  let(:spot) { create(:spot, user: user) }
  let(:image) do
    fixture_file_upload(Rails.root.join('spec/fixtures/sample.jpg'), 'image/jpeg')
  end

  describe "GET /spots" do
    it "spotの一覧表示の表示に成功する" do
      get spots_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /spots/new" do
    it "spotの新規投稿の表示に成功する" do
      sign_in user
      get new_spot_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /spots" do
    context "ログインしている場合" do
      it "スポットを作成できる" do
        sign_in user

        image = fixture_file_upload(Rails.root.join("spec/fixtures/sample.jpg"), "image/jpeg")

        expect do
          post spots_path, params: {
            spot: {
              name: "テストスポット",
              body: "テストです。",
              address: "港区",
              url: "https://example.com",
              prefecture_id: prefecture.id,
              image: image
            }
          }
        end.to change(Spot, :count).by(1)

        expect(response).to have_http_status(302)

        created_spot = Spot.last
        expect(created_spot.name).to eq('テストスポット')
        expect(created_spot.body).to eq('テストです。')
        expect(created_spot.address).to eq('港区')
        expect(created_spot.url).to eq('https://example.com')
        expect(created_spot.image).to be_attached
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        post spots_path,
          params: {
            spot: {
              name: "テストスポット",
              body: "テストです。",
              address: "港区",
              url: "https://example.com",
              prefecture_id: prefecture.id,
              image: image
            }
          }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /spots/:id" do
    it "spotの詳細ページの表示に成功する" do
      get spot_path(spot)
      expect(response).to have_http_status(200)
      expect(response.body).to include(spot.body)
    end
  end

  describe "GET /spots/:id/edit" do
    it "編集画面の表示に成功する" do
      sign_in user
      get edit_spot_path(spot)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH /spots/:id" do
    context "ログインしている場合" do
      it "spotを更新できる" do
        sign_in user
        patch spot_path(spot), params: {
          spot: {
            name: "更新されたスポット名"
          }
        }
        expect(response).to redirect_to(spot_path(spot))
        follow_redirect!
        expect(response.body).to include("更新されたスポット名")
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        patch spot_path(spot), params: {
          spot: {
            name: "不正な更新"
          }
        }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /spots/:id" do
    context "ログインしている場合" do
      it "spotを削除できる" do
        sign_in user
        spot_to_delete = create(:spot, user: user)
        expect do
          delete spot_path(spot_to_delete)
        end.to change(Spot, :count).by(-1)
        expect(response).to redirect_to(spots_path)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        delete spot_path(spot)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
