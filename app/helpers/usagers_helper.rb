module UsagersHelper
  def dates_ok(str)
  	if str.nil?
  	  str = ""
  	else
  	  arr = str.split(" - ").sort
  	  (0..(arr.length-1)).each do |n|
  	    t = arr[n].split('/').reverse.join('/')
        arr[n] = t
      end
      str = arr.join(' - ')
    end
  end

  def dates_sig_ok(str)
    if str.nil?
      str = ""
    else
      arr = str.split(" - ")
      arra = []
      arrb = [] 
      (0..(arr.length-1)).each do |n|
        arra << arr[n].split(' (').first.split('/').reverse.join('/')
        arrb << arr[n].split(' (').last
        arr[n] = arra[n]+ " ("+arrb[n]
      end
      str = arr.join(' - ')
    end
  end

  def dates_5(str)
    if str
      disp = dates_ok(str)
      if disp.length > 52
        d = disp.split(' - ')
        d[(d.length-5)..(d.length-1)].join(' - ') 
      else
        disp
      end
    end
  end
end