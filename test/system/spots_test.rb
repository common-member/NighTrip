require "application_system_test_case"

class SpotsTest < ApplicationSystemTestCase
  setup do
    @spot = spots(:one)
  end

  test "visiting the index" do
    visit spots_url
    assert_selector "h1", text: "Spots"
  end

  test "should create spot" do
    visit spots_url
    click_on "新規投稿"

    fill_in "Address", with: @spot.address
    fill_in "Body", with: @spot.body
    fill_in "Name", with: @spot.name
    fill_in "Prefecture", with: @spot.prefecture_id
    fill_in "Url", with: @spot.url
    fill_in "User", with: @spot.user_id
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
    # select @spot.user.name, from: "spot[user_id]"
    click_on "Update Spot"

    assert_text "Spot was successfully updated"
    click_on "Back"
  end

  test "should destroy Spot" do
    sign_in @user

    visit spot_url(@spot)

    accept_confirm do # 確認ダイアログ（JavaScript の confirm）が表示された際にキャンセルされる可能性があるため必要
      click_on "Destroy this spot", match: :first
    end

    assert_text "Spot was successfully destroyed"
  end
end
