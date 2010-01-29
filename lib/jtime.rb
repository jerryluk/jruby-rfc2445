require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class JTime
  include Comparable
  include_class('org.joda.time.DateTime'){|package,name| "J#{name}" }
  
  # Class Methods
  class << self
    # Creates a new time object with the given number of seconds (and optional
    # microseconds) from epoch.
    # 
    # ==== Options
    # +seconds+:: given number of seconds from epoch
    # +microseconds+:: Optional. microseconds from epoch
    #
    def at(seconds, microseconds=0)
      datetime = JDateTime.new(seconds * 1000 + microseconds)
      new(datetime)
    end
    
    # Creates a time based on given values, interpreted as UTC (GMT).
    # The year must be specified. Other values default to the minimum
    # value for that field.
    # 
    # ==== Options
    # +year+:: Year
    # +month+:: Optional. Numbers from 1 to 12, or by the three-letter
    #           English month names
    # +hour+:: Optional.24-hour clock (0..23)
    # +min+:: Optional. 0..59
    # +sec+:: Optional. seconds of the time
    # +usec+:: Optional. microsecond of the time
    def utc(year, month=1, day=1, hour=0, min=0, sec=0, usec=0)
      datetime = JDateTime.new(year, numeric_month(month), day, hour, min, sec, usec, 
                               org.joda.time.DateTimeZone::UTC)
      new(datetime)
    end
    
    # Same as JTime.utc, but interprets the values in local time zone
    def local(year, month=1, day=1, hour=0, min=0, sec=0, usec=0)
      datetime = JDateTime.new(year, numeric_month(month), day, hour, min, sec, usec)
      new(datetime)
    end
    
    # Initialize a JTime object form DateValue
    def from_date_value(dv, timezone = org.joda.time.DateTimeZone::UTC)
      datetime = JDateTime.new(dv.year, numeric_month(dv.month), dv.day, 0, 0, 0, 0, timezone)
      new(datetime)
    end
    
    # Initialize a JTime object from DateTimeValue
    def from_date_time_value(dtv)
      utc(dtv.year, dtv.month, dtv.day, dtv.hour, dtv.minute, dtv.second)
    end
    
    # Initialize a JTime object from Ruby Time object
    def from_time(time)
      datetime = JDateTime.new((time.to_f * 1000).to_i)
      new(datetime)
    end
    
    alias :now :new
    alias :gm :utc
    alias :mktime :local
    
    protected
    MONTH_NAME_HASH = {
      'jan' => 1,
      'feb' => 2,
      'mar' => 3,
      'apr' => 4,
      'may' => 5,
      'jun' => 6,
      'jul' => 7,
      'aug' => 8,
      'sep' => 9,
      'oct' => 10,
      'nov' => 11,
      'dec' => 12
    }
    
    def numeric_month(mon)
      return mon if mon.kind_of? Fixnum
      MONTH_NAME_HASH[mon.downcase]
    end
  end
  
  # Instance Methods
  
  # Returns a JTime object. If a Java DateTime object is passed, it is initialized
  # from the Java JDateTime object, otherwise it is initialized to the current
  # system time
  # 
  # ==== Options
  # +datetime+:: Optional. The Java DateTime (org.joda.time.DateTime')object
  #
  def initialize(datetime = JDateTime.new)
    @time = datetime
    self
  end
  
  # Returns a Ruby Time object
  def to_time
    millis = @time.getMillis
    Time.at(millis / 1000, millis % 1000 * 1000)
  end
  
  # Returns the underlying Java DateTime object
  def to_java
    @time
  end
  
  # Returns the value of time as an integer number of seconds since epoch
  def to_i
    @time.getMillis / 1000
  end
  
  # Returns the value of time as a floating point number of seconds since epoch
  def to_f
    @time.getMillis / 1000.0
  end
  
  # Returns a string representing JTime
  def to_s
    @time.toString
  end

  # Returns a new JTime object in UTC time. The receiver is unchanged
  # IMPORTANT: The original utc in Ruby modified the receiver object
  def utc
    datetime = @time.toDateTime(org.joda.time.DateTimeZone::UTC)
    self.class.new(datetime)
  end
  
  def <=>(another_time)
    @time.compareTo(another_time.to_java)
  end
  
  def year
    @time.getYear
  end
  
  def month
    @time.getMonthOfYear
  end
  
  def day
    @time.getDayOfMonth
  end
  
  def hour
    @time.getHourOfDay
  end
  
  def min
    @time.getMinuteOfHour
  end
  
  def sec
    @time.getSecondOfMinute
  end
  
  def wday
    @time.getDayOfWeek
  end
  
  def yday
    @time.getDayOfYear
  end
  
  def week
    @time.getWeekOfWeekyear
  end
  
  # Returns the name of the timezone used for time. 
  # IMPORTANT: Unlike Ruby Time, which returns "PST"
  # it actuallys return real timezone ID such as 'America/Los_Angeles'
  def zone
    @time.getZone.getID
  end
  
  # Returns DateTimeValue object
  def to_date_time_value
    com.google.ical.values.DateTimeValueImpl.new(self.year, self.month, self.day, self.hour, self.min, self.sec)
  end
  
  # Returns the Java Timezone object
  def java_zone
    @time.getZone
  end
  
  # Returns true if time occurs during Daylight Saveing Time in its timeezone
  def isdst
    timezone = @time.getZone.toTimeZone
    timezone.inDaylightTime(@time.toDate)
  end
  
  # We should consider getting rid of this or implement this using meta-programming
  def method_missing(key, *params)
    @time.send(key, *params)
  end
  
  alias :mon :month
  alias :dst? :isdst
  
end