module StatsHelper
  def is_number?(string)
    true if Float(string) rescue false
  end

  def stats_ville
    session[:stored_ville] = request.url if request.get?
    session[:stored_ville] = session[:stored_ville].split('/').last.split('%20').join(' ')
    if is_number?(session[:stored_ville].split('-').last) || session[:stored_ville] == "stats"
      session[:stored_ville] = nil
    end
  end

  def stats_dates
    lollipop = request.url if request.get?
    lollipop = lollipop.split('/')
    if is_number?(lollipop.last.split('-').last)
      session[:stored_dates] = [lollipop[lollipop.length-2], lollipop[lollipop.length-1]]
    elsif is_number?(lollipop[lollipop.length-2].split('-').last)
      session[:stored_dates] = [lollipop[lollipop.length-3], lollipop[lollipop.length-2]]
    else
      session[:stored_dates] = nil
    end
  end
end