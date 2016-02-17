require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get guide" do
    get :guide
    assert_response :success
  end

end
