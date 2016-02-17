class StaticController < ApplicationController
  before_action :logged_in_user, only: :guide

  def guide
  end
end
