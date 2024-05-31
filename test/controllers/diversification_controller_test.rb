require "test_helper"

class DiversificationControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get diversification_index_url
    assert_response :success
  end
end
