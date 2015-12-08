require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "login with invalid information" do
    get root_path
    assert_template 'sessions/new'
    post login_path, session: { identifiant: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get root_path
    post login_path, session: { identifiant: 'MichEx', password: 'password' }
    assert is_logged_in?
    assert_redirected_to usagers_path
    follow_redirect!
    assert_template 'usagers/index'
    assert_select "a[href=?]", logout_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!    
  end

  test "redirect login when logged in" do
    log_in_as(@user)
    post login_path, session: { identifiant: 'SterArch', password: 'password'}
    assert_redirected_to root_url
  end
end
