class StaticController < ApplicationController
  before_action :logged_in_user, only: :guide

  def guide
  	if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  end
end
