class UsersController < ApplicationController
  before_action :logged_in_user, 	only: [:new, :create, :index, :show, :edit, :update, :destroy]
  before_action :correct_user, 		only: [:edit, :update]
  before_action :admin_user,		  only: [:new, :create, :destroy]
  before_action :benev_user,      only: [:new, :create, :destroy]

  def index
    if session.has_key?('groupe')
      session.delete(:usager_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    if session.has_key?('groupe')
      session.delete(:usager_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@user = User.find(params[:id])
  end

  def new
    if session.has_key?('groupe')
      session.delete(:usager_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@user = User.new
  	if logged_in?
  		admin_user
  	end
  end

  def create
  	@user = User.new(user_params)
  	if @user.save && logged_in?
  	  if params[:user][:admin] == '1'
  	    flash[:success] = "Nouvel administrateur créé !"
  	 	  redirect_to @user
  	 	else
     	  flash[:success] = "Nouvel utilisateur créé !"
	  	  redirect_to @user
	  	end
  	else
  	  render 'new'
    end
  end

  def edit
    if session.has_key?('groupe')
      session.delete(:usager_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
    end
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update_attributes(user_params)
  	  flash[:success] = "Profil édité"
  	  redirect_to @user
  	else
  	  render 'edit'
  	end
  end

  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "Utilisateur supprimé"
  	redirect_to users_url
  end

  private

    def user_params
      if logged_in? && current_user.admin?
      	params.require(:user).permit( :nom,
      								  :prenom,
      								  :identifiant,
      								  :password,
      								  :password_confirmation,
      								  :admin,
                        :benev)
      else
      	params.require(:user).permit( :nom,
      								  :prenom,
      								  :identifiant,
      								  :password,
      								  :password_confirmation)
      end
    end

    def logged_in_user
      unless logged_in?
      	flash[:danger] = "Merci de vous connecter."
      	redirect_to root_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || current_user.admin?
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
