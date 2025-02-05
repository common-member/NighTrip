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
    click_on "Back"
  end

  test "should update Spot" do
    visit spot_url(@spot)
    click_on "Edit this spot", match: :first

    fill_in "spot_address", with: @spot.address
    fill_in "spot_body", with: @spot.body
    fill_in "spot_name", with: @spot.name
    select @spot.prefecture.name, from: "spot[prefecture_id]"
    fill_in "spot_url", with: @spot.url
    attach_file "spot_image", Rails.root.join("test/fixtures/files/test_image.png")
    click_on "Update Spot"

    assert_text "Spot was successfully updated"
    click_on "Back"
  end

  test "should destroy Spot" do
    visit spot_url(@spot)

    click_on "Destroy this spot", match: :first

    assert_text "Spot was successfully destroyed"
  end
end
