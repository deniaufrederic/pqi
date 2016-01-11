require 'test_helper'

class UsagersCreateTest < ActionDispatch::IntegrationTest
  def setup
  	@user = users(:michael)
  end

  test "invalid create information" do
  	log_in_as(@user)
    get usagers_path
    assert_no_difference 'Usager.count' do
      post add_path, usager: { 	nom:  "",
                             	prenom: "",
                           	    sexe: "",
                                ville: "",
                                date_naissance: "",
                                tel: "",
                                notes: "" }
    end
    assert_not flash.empty?
  end

  test "valid create information" do
  	log_in_as(@user)
    get usagers_path
    assert_difference 'Usager.count', 1 do
      post_via_redirect add_path, usager: { nom:  "Louis",
                           					prenom: "Emile",
                           	 			    sexe: "Mr",
                             			    ville: "Aubervilliers",
                                			date_naissance: "",
                              			    tel: "",
                             			    notes: "" }
    end
    assert_template 'usagers/rencontre'
    assert_not flash.empty?
  end
end
