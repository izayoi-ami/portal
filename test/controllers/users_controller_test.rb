require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get settings" do
    get :settings
    assert_response :success
  end

  test "should get change_password" do
    get :change_password
    assert_response :success
  end

end
