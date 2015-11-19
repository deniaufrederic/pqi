require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { nom:  "",
                               prenom: "",
                               identifiant: "",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { nom:  "Exemple",
                               				      prenom: "Exemple",
                               				      identifiant: "Exzoo",
                               			      	password:              "password",
                              				      password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end

  test "invalid signup information by admin" do
    log_in_as(@admin)
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { nom:  "",
                               prenom: "",
                               identifiant: "",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information by admin" do
    log_in_as(@admin)
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { nom:  "Exemple",
                                            prenom: "Exemple",
                                            identifiant: "Exzoo",
                                            password:              "password",
                                            password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert_not flash.empty?
  end

  test "valid admin signup information by admin" do
    log_in_as(@admin)
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { nom:  "Exemple",
                                            prenom: "Exemple",
                                            identifiant: "Exzoo",
                                            password:              "password",
                                            password_confirmation: "password",
                                            admin: "1" }
    end
    assert_template 'users/show'
    assert_match "Administrateur", response.body
    assert_not flash.empty?
  end

  test "get signup as non admin" do
    log_in_as(@non_admin)
    get signup_path
    assert_redirected_to root_url
  end
end