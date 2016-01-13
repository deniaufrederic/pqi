require 'test_helper'

class UsagersControllerTest < ActionController::TestCase
  
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

  test "should redirect edit when not logged in" do
    get :edit, id: @usager
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect create when not logged in" do
    post :create, usager: { nom: @usager.nom,
                            sexe: @usager.sexe,
                            ville: @usager.ville,
                            user_id: @usager.user_id }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @usager, usager: { 	nom: @usager.nom,
    										prenom: @usager.prenom,
    										sexe: @usager.sexe,
                        user_id: @usager.user_id,
                        ville: @usager.ville }
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Usager.count' do
      delete :destroy, id: @usager
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'Usager.count' do
      delete :destroy, id: @usager
    end
    assert_redirected_to root_url
  end

  test "should redirect show if not logged in" do
    get :show, id: @usager
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect pqi if not logged in" do
    get :pqi
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect rencontre if not logged in" do
    get :rencontre, id: @usager
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
