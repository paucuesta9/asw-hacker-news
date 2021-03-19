require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get helloworld" do
    get home_helloworld_url
    assert_response :success
  end
end
