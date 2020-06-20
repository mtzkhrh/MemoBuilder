require 'test_helper'

class Admins::MemosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admins_memos_index_url
    assert_response :success
  end

  test "should get show" do
    get admins_memos_show_url
    assert_response :success
  end

  test "should get edit" do
    get admins_memos_edit_url
    assert_response :success
  end

end
