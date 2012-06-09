class Time
  def year
    NSCalendar.currentCalendar.components(NSYearCalendarUnit, fromDate:self).year
  end
end