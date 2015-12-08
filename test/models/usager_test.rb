require 'test_helper'

class UsagerTest < ActiveSupport::TestCase
  def setup
    @usager = Usager.new(	nom: "Michel", prenom: "Michel", sexe: "Mr", ville: "Bondy",
    				 	            tel: "0101010101", user_id: "1")
  end

  test "should be valid" do
    assert @usager.valid?
  end

  test "user id should be present" do
    @usager.user_id = nil
    assert_not @usager.valid?
  end

  test "ville should be present" do
    @usager.ville = nil
    assert_not @usager.valid?
  end

  test "sexe should be present" do
  	@usager.sexe = nil
  	assert_not @usager.valid?
  end

  test "should at least have a first or a last name" do
  	@usager.nom = "    "
  	@usager.prenom = "    "
  	assert_not @usager.valid?
  end

  test "should at least have a first or a last name_2" do
  	@usager.prenom = "    "
  	assert @usager.valid?
  end

  test "should at least have a first or a last name_3" do
  	@usager.nom = "    "
  	assert @usager.valid?
  end

  test "tel validation should accept blank tels" do
    @usager.tel = "   "
    assert @usager.valid?
  end

  test "tel validation should reject invalid tels" do
    invalid_tels = %w[01 010101010 01010101010 dsdsdsdsds]
    invalid_tels.each do |invalid_tel|
      @usager.tel = invalid_tel
      assert_not @usager.valid?, "#{invalid_tel.inspect} should be invalid"
    end
  end

  test "adresse validation should accept blank adresses" do
    @usager.adresse = "   "
    assert @usager.valid?
  end

  test "should accept valid adresses" do
    @usager.adresse = "45 rue de l'Alouette"
    assert @usager.valid?
  end

  test "order should be alphabetical" do
    assert_equal usagers(:first), Usager.first
  end
end