require "application_system_test_case"

class SpotsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @user = User.create!(
      email: "user@example.com",
      password: "password",
      name: "Test User"
    )

    sign_in @user  # ログイン処理

    # prefecture = Prefecture.find_by(name: "東京都") || Prefecture.create!(name: "東京都", region: 2)

    @spot = Spot.create!(
      name: "テストスポット",
      address: "新宿区内藤町１１",
      url: "https://example.com",
      body: "テスト用のスポットです。",
      prefecture_id: 13,
      user: @user,
      image: Rack::Test::UploadedFile.new(Rails.root.join("test/fixtures/files/test_image.png"), "image/png")
    )
  end

  test "visiting the index" do
    visit spots_url
    assert_selector "h2", text: @spot.name
  end

  test "should create spot" do
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
    visit spot_url(@spot)

    accept_alert do
      click_on "投稿を削除", match: :first
    end

    assert_text "Spot was successfully destroyed"
  end
end
