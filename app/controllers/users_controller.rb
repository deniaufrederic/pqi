class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  	  log_in @user
  	  flash[:success] = "Vous pouvez désormais accéder à l'application PQI !"
  	  redirect_to @user
  	else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit( :nom,
      								:prenom,
      								:identifiant,
      								:password,
      								:password_confirmation)
    end
end
