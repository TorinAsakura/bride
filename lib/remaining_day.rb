module Password
  def timespan_in_DHMS(time1, time2)
    # returns an array with number of days, hours, minutes and seconds. 
    days, remaining = (time1-time2).to_i.abs.divmod(86400) 
    hours, remaining = remaining.divmod(3600)
    minutes, seconds = remaining.divmod(60)
    [days, hours, minutes, seconds]
  end  
end
