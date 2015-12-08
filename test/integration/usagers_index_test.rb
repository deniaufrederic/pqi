require 'test_helper'

class UsagersIndexTest < ActionDispatch::IntegrationTest

  def setup
  	@admin = users(:michael)
  	@non_admin = users(:archer)
  	@usager = usagers(:poto)
  end

  test "should get index as root if logged in" do
  	log_in_as(@admin)
  	get root_path
  	assert_redirected_to usagers_url
  end

  test "index as admin including pagination and deleting" do
    log_in_as(@admin)
    get usagers_path
    assert_template 'usagers/index'
    assert_select 'div.pagination'
    assert_difference 'Usager.count', -1 do
      delete usager_path(@usager)
    end
  end

  test "index as non-admin including pagination" do
    log_in_as(@non_admin)
    get usagers_path
    assert_template 'usagers/index'
    assert_select 'div.pagination'
    assert_select 'a', text: 'Supprimer', count: 0
  end
end