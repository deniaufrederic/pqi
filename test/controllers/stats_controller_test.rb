require 'test_helper'

class StatsControllerTest < ActionController::TestCase
  def setup
  	@user = users(:michael)
  	@other_user = users(:archer)
  	@usager = usagers(:poto)
  end

  test "should redirect show if not logged in" do
	get :show
  	assert_not flash.empty?
	assert_redirected_to root_url	 
  end

  test "should redirect create (dates) when not logged in" do
    post :create, date_deb: "2016-01-01", date_fin: "2016-01-31"
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect create (dates and ville) when not logged in" do
    post :create, date_deb: "2016-01-01", date_fin: "2016-01-31", ville: "Bondy"
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end