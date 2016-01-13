require 'test_helper'

class MaraudeTest < ActiveSupport::TestCase
  def setup
    @maraude = Maraude.new(	date: "2016-01-01", rencontres: "", signalements: "", accompagnements: "")
  end

  test "should be valid" do
    assert @maraude.valid?
  end

  test "date should be present" do
    @maraude.date = nil
    assert_not @maraude.valid?
  end
end
