require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(nom: "Michel", prenom: "Michel", identifiant: "michmich93",
    				 password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "identif should be present" do
    @user.identifiant = " " * 6
    assert_not @user.valid?
  end

  test "identif should not be too long" do
    @user.identifiant = "a" * 26
    assert_not @user.valid?
  end

  test "identif should not be too short" do
    @user.identifiant = "a" * 5
    assert_not @user.valid?
  end

  test "prenom should not be too long" do
    @user.prenom = "a" * 26
    assert_not @user.valid?
  end

  test "nom should not be too long" do
    @user.nom = "a" * 26
    assert_not @user.valid?
  end

  test "nom should be present" do
    @user.nom = "    "
    assert_not @user.valid?
  end

  test "prenom should be present" do
    @user.prenom = "    "
    assert_not @user.valid?
  end

  test "identif should be unique" do
    duplicate_user = @user.dup
    duplicate_user.identifiant = @user.identifiant.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "identifs should be saved as lower-case" do
    mixed_case_identif = "FooExAMPle.CoM"
    @user.identifiant = mixed_case_identif
    @user.save
    assert_equal mixed_case_identifiant.downcase, @user.reload.identifiant
  end
end
