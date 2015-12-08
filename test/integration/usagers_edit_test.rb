require 'test_helper'

class UsagersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @usager = usagers(:poto)
  end

  test "unsuccessful edit" do
  	log_in_as(@user)
    get edit_usager_path(@usager)
    assert_template 'usagers/edit'
    patch usager_path(@usager), usager: { nom:  "",
                                   		  prenom: "",
                                    	  sexe: "",
                                        ville: "" }
    assert_template 'usagers/edit'
  end

  test "successful edit" do
  	log_in_as(@user)
    get edit_usager_path(@usager)
    assert_template 'usagers/edit'
    nom  = "BAR"
    prenom = "Foo"
    sexe = "Mme"
    ville = "Bagnolet"
    patch usager_path(@usager), usager: { nom: nom,
    							                        prenom: prenom,
                                    	    sexe: sexe,
                                          ville: ville }
    assert_not flash.empty?
    assert_redirected_to @usager
    @usager.reload
    assert_equal nom, @usager.nom
    assert_equal prenom, @usager.prenom
    assert_equal sexe,  @usager.sexe
    assert_equal ville, @usager.ville
  end

  test "should not edit user_id param" do
    log_in_as(@user)
    get edit_usager_path(@usager)
    assert_template 'usagers/edit'
    user_id = 2
    patch usager_path(@usager), usager: { user_id: user_id }
    @usager.reload
    assert_not_equal user_id, @usager.user_id
  end
end
