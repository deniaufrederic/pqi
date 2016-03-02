module StatsHelper
  def is_number?(string)
    true if Float(string) rescue false
  end

  def stats_store
    lollipop = request.url.split('/') if request.get?
    n = lollipop.length
    if is_number?(lollipop.last.split('-').last)
      session[:stored_dates] = [lollipop[n-2], lollipop[n-1]]
      session[:stored_ville] = nil
      session[:stored_type] = nil
    elsif is_number?(lollipop[n-3].split('-').last)
      session[:stored_dates] = [lollipop[n-4], lollipop[n-3]]
      if lollipop[n-2] == "type"
        session[:stored_type] = lollipop.last.split('%20').join(' ').split('%C3%A9').join('é').split('%C3%B4').join('ô')
        session[:stored_ville] = nil
      elsif lollipop[n-2] == "ville"
        session[:stored_ville] = lollipop.last.split('%20').join(' ').split('%C3%A9').join('é').split('%C3%B4').join('ô')
        session[:stored_type] = nil
      else
        session[:stored_type] = lollipop[n-2].split('%20').join(' ').split('%C3%A9').join('é').split('%C3%B4').join('ô')
        session[:stored_ville] = lollipop.last.split('%20').join(' ').split('%C3%A9').join('é').split('%C3%B4').join('ô')
      end
    else
      session[:stored_dates] = nil
      session[:stored_ville] = nil
      session[:stored_type] = nil
    end
  end
end