require 'test_helper'

class TaskListControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get task_list_index_url
    assert_response :success
  end

  test "should get new" do
    get task_list_new_url
    assert_response :success
  end

  test "should get show" do
    get task_list_show_url
    assert_response :success
  end

  test "should get edit" do
    get task_list_edit_url
    assert_response :success
  end

end
