require 'test_helper'

class MaraudesControllerTest < ActionController::TestCase

  def setup
  	@user = users(:michael)
  	@other_user = users(:archer)
  	@usager = usagers(:poto)
  end

  test "should redirect index if not logged in" do
  	get :index
  	assert_not flash.empty?
  	assert_redirected_to root_url
  end
end
