require "test_helper"

class PostHobbiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get post_hobbies_new_url
    assert_response :success
  end

  test "should get index" do
    get post_hobbies_index_url
    assert_response :success
  end

  test "should get show" do
    get post_hobbies_show_url
    assert_response :success
  end

  test "should get edit" do
    get post_hobbies_edit_url
    assert_response :success
  end

  test "should get drafts" do
    get post_hobbies_drafts_url
    assert_response :success
  end

  test "should get favorites" do
    get post_hobbies_favorites_url
    assert_response :success
  end
end
