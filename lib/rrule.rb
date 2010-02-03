require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class RRule
  include_class('com.google.ical.values.RRule'){|package,name| "J#{name}" }
  
  RRULE = 'RRULE'
  EXRULE = 'EXRULE'
  VEVENT = 'VEVENT'
  
  # Initializes a Recurrence Rule with optionally an iCal string
  #
  # ==== Options
  # +ical_string+:: Optional. The iCal string for the recurrent rule.
  #                 The string must specify the rule type (RRULE, EXRULE or VEVENT)
  # 
  def initialize(ical_string=nil)
    @rrule = ical_string ? JRRule.new(ical_string) : JRRule.new
    self
  end
  
  # Returns the underlying Java object
  def to_java
    @rrule
  end
  
  # Returns the unfolded RFC 2445 content line.
  def to_ical
    @rrule.toIcal
  end
  
  # Returns a hash map of any extension parameters such as
  # the X-FOO=BAR in RRULE;X-FOO=BAR
  def ext_params
    h = {}
    @rrule.getExtParams.to_a.each do |p|
      h[p[0]] = p[1]
    end
    h
  end
  
  def count
    @rrule.getCount
  end
  
  # ==== Options
  # +new_count+:: number of count
  def count=(new_count)
    @rrule.setCount(new_count)
    self
  end
  
  def hours
    @rrule.getByHour.to_a
  end
  
  # ==== Options
  # +new_hours+:: array of numbers (0..23)
  def hours=(new_hours=[])
    @rrule.setByHour(new_hours.to_java(:int))
    self
  end
  
  def minutes
    @rrule.getByMinute.to_a
  end
  
  # ==== Options
  # +new_minutes+:: array of numbers (0..59)
  def minutes=(new_minutes=[])
    @rrule.setByMinute(new_minutes.to_java(:int))
    self
  end
  
  def months
    @rrule.getByMonth.to_a
  end
  
  # ==== Options
  # +new_months+:: array of numbers (1..12)
  def months=(new_months=[])
    @rrule.setByMonth(new_months.to_java(:int))
    self
  end
  
  # Gets the days of month
  def mdays
    @rrule.getByMonthDay.to_a
  end
  
  # Sets the days of month
  # 
  # ==== Options
  # +new_mdays+:: array of days of month (1..31)
  def mdays=(new_mdays=[])
    @rrule.setByMonthDay(new_mdays.to_java(:int))
    self
  end
  
  def seconds
    @rrule.getBySecond.to_a
  end
  
  # ==== Options
  # +new_seconds+:: array of days of month (0..59)
  def seconds=(new_seconds=[])
    @rrule.setBySecond(new_seconds.to_java(:int))
    self
  end
  
  def setpos
    @rrule.getBySetPos.to_a
  end
  
  def setpos=(new_setpos=[])
    @rrule.setByPos(new_setpos.to_java(:int))
    self
  end
  
  def weeknums
    @rrule.getByWeekNo.to_a
  end
  
  # Sets the numbers of week
  # 
  # ==== Options
  # +new_weeknums+:: array of weeks (1..52)
  def weeknums=(new_weeknums=[])
    @rrule.setByWeekNo(new_weeknums.to_java(:int))
    self
  end
  
  # Gets the day of year
  def ydays
    @rrule.getByYearDay.to_a
  end
  
  # Sets the day of year
  # 
  # ==== Options
  # +new_ydays+:: array of day of year (1..365)
  def ydays=(new_ydays=[])
    @rrule.setByYearDay(new_ydays.to_java(:int))
    self
  end
  
  # Gets the recurrence frequency, return type is defined in
  # "com.google.ical.values.Frequency", such as Frequency::MONTHLY
  def frequency
    @rrule.getFreq
  end
  
  # Sets the recurrence frequency
  # 
  # ==== Options
  # +freq+:: defined in com.google.ical.values.Frequency, such as
  #          Frequency::MONTHLY or Frequency::DAILY
  def frequency=(freq)
    @rrule.setFreq(freq)
    self
  end
  
  def interval
    @rrule.getInterval
  end
  
  def interval=(new_interval)
    @rrule.setInterval(new_interval)
    self
  end
  
  # Returns the type of the recurrence rule such as
  # RRULE, EXRULE, or VEVENT
  def name
    @rrule.getName
  end
  
  # Sets the type of the recurrence rule such as
  # RRULE, EXRULE, or VEVENT
  # 
  # ==== Options
  # +new_name+:: 'RRULE', 'EXRULE', or 'VEVENT'
  def name=(new_name)
    @rrule.setName(new_name)
    self
  end
  
  # Gets the WeekdayNums for the recurrence rule
  # WeekdayNum is an object which specifies the week of year
  # and the day of week
  def days
    @rrule.getByDay.to_a.map do |d|
      WeekdayNum.new(d)
    end
  end
  
  # Sets the WeekdayNums for the recurrence rule
  # WeekdayNum is an object which specifies the week of year
  # and the day of week
  # 
  # ==== Options
  # +new_days+:: Array of WeekdayNums
  def days=(new_days)
    @rrule.setByDay(new_days.map {|d| d.to_java})
    self
  end
  
  # Gets the starting day of the week (0-6)
  def wdaystart
    weekday = @rrule.getWkSt
    Weekday::MAP[weekday]
  end
  
  # Sets the starting day of the week (0-6, Mon-Sun, Mo-Su)
  # 
  # ==== Options
  # +wday+:: 0-6, 'Mon' - 'Sun', or 'Mo' - 'Su'
  def wdaystart=(wday)
    wday = Weekday::MAP[wday.to_s.downcase]
    @rrule.setWkSt(wday)
    self
  end
  
  # Gets the end date, assume it is UTC for now
  def until
    d = @rrule.getUntil
    case d
    when DateTimeValue
      JTime.from_date_time_value(d)
    when DateValue
      JTime.from_date_value(d)
    else
      nil
    end
  end
  
  # Sets the end date
  # 
  # ==== Options
  # +new_date+:: JTime object
  def until=(new_date)
    d = com.google.ical.values.DateTimeValueImpl.new(new_date.year, new_date.month, new_date.day, new_date.hour, new_date.min, new_date.sec)
    @rrule.setUntil(d)
    self
  end
  
  # We should consider getting rid of this or implement this using meta-programming
  def method_missing(key, *params)
    @rrule.send(key, *params)
  end
end