require "application_system_test_case"

class SpotsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(email: "user@example.com", password: "password", name: "Test User") # @user の作成
    sign_in @user  # ログイン処理
    @spot = spots(:one) # 既存のスポットデータを使用
  end

  test "visiting the index" do
    visit spots_url
    assert_selector "h1", text: "Spots"
  end

  test "should create spot" do
    sign_in @user
    visit spots_url
    click_on "新規投稿"

    fill_in "spot_address", with: @spot.address
    fill_in "spot_body", with: @spot.body
    fill_in "spot_name", with: @spot.name
    select @spot.prefecture.name, from: "spot[prefecture_id]"
    fill_in "spot_url", with: @spot.url
    attach_file "spot_image", Rails.root.join("test/fixtures/files/test_image.png")
    click_on "Create Spot"

    assert_text "Spot was successfully created"
    click_on "投稿一覧に戻る"
  end

  test "should update Spot" do
    sign_in @user
    visit spot_url(@spot)
    click_on "投稿を編集", match: :first

    fill_in "spot_address", with: @spot.address
    fill_in "spot_body", with: @spot.body
    fill_in "spot_name", with: @spot.name
    select @spot.prefecture.name, from: "spot[prefecture_id]"
    fill_in "spot_url", with: @spot.url
    attach_file "spot_image", Rails.root.join("test/fixtures/files/test_image.png")
    click_on "Update Spot"

    assert_text "Spot was successfully updated"
    click_on "投稿一覧に戻る"
  end

  test "should destroy Spot" do
    sign_in @user
    visit spot_url(@spot)

    click_on "投稿を削除", match: :first

    assert_text "Spot was successfully destroyed"
  end
end
