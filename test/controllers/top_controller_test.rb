require "test_helper"

class TopControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get top_home_url
    assert_response :success
  end
end
