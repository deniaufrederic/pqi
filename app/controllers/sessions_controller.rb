class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to usagers_path
    end
  end

  def create
  	@user = User.find_by(identifiant: params[:session][:identifiant])
  	if logged_in?
      redirect_to root_path
    else
      if @user && @user.authenticate(params[:session][:password])
  	    log_in @user
  	    redirect_to usagers_path
  	  else
  	    flash.now[:danger] = "Combinaison identifiant/mot de passe invalide"
  	    render 'new'
  	  end
    end
  end

  def destroy
  	log_out
  	redirect_to root_url
  end
end
