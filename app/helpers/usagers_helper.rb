module UsagersHelper
  def dates_5(dat)
    if dat
      if dat.length > 52
        d = dat.split(' - ')
        d[0..4].join(' - ') 
      else
        dat
      end
    end
  end
end