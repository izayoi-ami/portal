require 'test_helper'

class DisciplineControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get letter" do
    get :letter
    assert_response :success
  end

end
