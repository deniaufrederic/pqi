require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { 	nom: @user.nom,
    									prenom: @user.prenom,
    									identifiant: @user.identifiant }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect edit when logged in as non-admin wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as non-admin wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { 	nom: @user.nom,
    									prenom: @user.prenom,
    									identifiant: @user.identifiant }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should not accept to edit admin if non-admin" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { admin: false }
    assert @user.admin?
  end
end
