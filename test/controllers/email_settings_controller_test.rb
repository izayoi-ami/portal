require 'test_helper'

class EmailSettingsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get auto_forward" do
    get :auto_forward
    assert_response :success
  end

  test "should get auto_response" do
    get :auto_response
    assert_response :success
  end

  test "should get update_response" do
    get :update_response
    assert_response :success
  end

end
