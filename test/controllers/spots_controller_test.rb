require "test_helper"

class SpotsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    # 動的にユーザーを作成（ユーザーのインデックスは `n` に基づく）
    @user = User.create!(
      email: "user#{Time.now.to_i}0@example.com",  # この部分は動的に変更
      password: "password",
      name: "user0"
    )

    sign_in @user  # ログイン処理
    @spot = Spot.create(name: "Test Spot", address: "Test Address", body: "Test Body", prefecture_id: 1, url: "http://example.com", user_id: @user.id)
  end

  test "should get index" do
    get spots_url
    assert_response :success
  end

  test "should get new" do
    get new_spot_url
    assert_response :success
  end

  test "should create spot" do
    assert_difference("Spot.count") do
      post spots_url, params: { spot: { address: @spot.address, body: @spot.body, name: @spot.name, prefecture_id: @spot.prefecture_id, url: @spot.url, user_id: @user.id } }
    end

    assert_redirected_to spot_url(Spot.last)
  end

  test "should show spot" do
    get spot_url(@spot)
    assert_response :success
  end

  test "should get edit" do
    get edit_spot_url(@spot)
    assert_response :success
  end

  test "should update spot" do
    patch spot_url(@spot), params: { spot: { address: @spot.address, body: @spot.body, name: @spot.name, prefecture_id: @spot.prefecture_id, url: @spot.url } }
    assert_redirected_to spot_url(@spot)
  end

  test "should destroy spot" do
    assert_difference("Spot.count", -1) do
      delete spot_url(@spot)
    end

    assert_redirected_to spots_url
  end
end
