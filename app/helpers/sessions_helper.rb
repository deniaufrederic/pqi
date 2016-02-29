module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
  	user == current_user
  end

  def current_user
  	@current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
  	!current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def store_ville
    session[:stored_ville] = request.url if request.get?
    session[:stored_ville] = session[:stored_ville].split('/').last.split('%20').join(' ')
  end

  def store_id
    session[:stored_id] = request.url if request.get? || request.post?
    session[:stored_id] = session[:stored_id].split('/').last
  end

  def store_last
    session[:stored] = request.url if request.get?
    s = session[:stored].split('/')
    session[:stored] = s[s.length-2]
  end

  # Friendly forwarding
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

  # Enlever infos de rencontres groupées
  def delete_groupe
    if session.has_key?('groupe')
      session.delete(:usagers_ids)
      session.delete(:groupe)
      session.delete(:date)
      session.delete(:type_renc)
      session.delete(:ville)
    end
  end
end