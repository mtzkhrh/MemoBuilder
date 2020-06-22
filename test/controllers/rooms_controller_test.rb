require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get rooms_show_url
    assert_response :success
  end

  test "should get edit" do
    get rooms_edit_url
    assert_response :success
  end
end
