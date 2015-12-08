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
end