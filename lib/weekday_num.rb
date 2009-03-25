require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class WeekdayNum
  include_class('com.google.ical.values.WeekdayNum'){|package,name| "J#{name}" }
  
  # Initializes a WeekdayNum objects.
  # It accepts a Java WeekdayNum object (com.google.ical.values.WeekdayNum) or
  # the number of the week and the day of the week
  def initialize(*args)
    if args.size == 1
      @weekdaynum = args[0]
    elsif args.size == 2
      num = args[0]
      wday = args[1]
      @weekdaynum = JWeekdayNum.new(num, Weekday::MAP[wday.to_s.downcase])
    end
    self
  end
  
  def to_ical
    @weekdaynum.toIcal
  end
  
  def to_s
    @weekdaynum.toString
  end
  
  def ==(weekdaynum)
    @weekdaynum.equals(weekdaynum.to_java)
  end
  
  def to_java
    @weekdaynum
  end
end