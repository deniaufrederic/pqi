require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
  	log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { nom:  "",
                                    prenom: "",
                                    identifiant: "",
                                    password:              "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit" do
  	log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    nom  = "Bar"
    prenom = "Foo"
    identifiant = "Foo@Bar"
    patch user_path(@user), user: { nom: nom,
    								prenom: prenom,
                                    identifiant: identifiant,
                                    password:              "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal nom,  @user.nom
    assert_equal prenom, @user.prenom
    assert_equal identifiant,  @user.identifiant
  end
end