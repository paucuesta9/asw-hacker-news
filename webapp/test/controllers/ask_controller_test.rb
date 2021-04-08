require "test_helper"

class AskControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ask_index_url
    assert_response :success
  end
end
