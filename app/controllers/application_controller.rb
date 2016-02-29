class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include StatsHelper
  include StaticHelper

  private

  	def logged_in_user
      unless logged_in?
        flash[:danger] = "Merci de vous connecter."
        redirect_to root_url
      end
    end

    def admin_user
      unless current_user.admin?
        store_location
        flash[:danger] = "Accès restreint (privilège administrateur)"
        redirect_back_or(root_url)
      end
    end

    def benev_user
      if current_user.benev?
        store_location
        flash[:danger] = "Accès réservé aux salariés"
        redirect_back_or(root_url)
      end
    end
end