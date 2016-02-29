module StaticHelper
	def store_choix
		session[:stored_choix] = request.url if request.get?
    session[:stored_choix] = session[:stored_choix].split('/').last
    if session[:stored_choix] == "listes"
      session[:stored_choix] = nil
    end
	end
end