require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class RDateList
  include_class('com.google.ical.values.RDateList') { |package,name| "J#{name}" }
  include_class('java.util.TimeZone') { |package,name| "J#{name}" }
  
  RDATE = 'RDATE'
  EXDATE = 'EXDATE'
  VEVENT = 'VEVENT'
  
  # Initializes a RDateList with optionally a time zone ID and an iCal string
  #
  # ==== Options
  # +timezone+:: Optional. Time zone ID. For instance, the time zone ID for the 
  #              U.S. Pacific Time zone is "America/Los_Angeles"
  #              If no timezone is specify, it uses time zone where the program
  #              is run
  # +ical_string+:: Optional. The iCal string for the recurrent rule.
  #                 The string must specify the rule type (RRULE, EXRULE or VEVENT)
  #
  def initialize(timezone=nil, ical_string=nil)
    tz = timezone ? JTimeZone.getTimeZone(timezone) : JTimeZone.getDefault
    @rdatelist = ical_string ? 
                 JRDateList.new(ical_string, tz) :
                 JRDateList.new(tz)
    self
  end
  
  # Returns the underlying Java object
  def to_java
    @rdatelist
  end
  
  # Returns the unfolded RFC 2445 content line.
  def to_ical
    @rdatelist.toIcal
  end
  
  # Returns a hash map of any extension parameters such as
  # the X-FOO=BAR in RRULE;X-FOO=BAR
  def ext_params
    h = {}
    @rdatelist.getExtParams.to_a.each do |p|
      h[p[0]] = p[1]
    end
    h
  end
  
  # Returns the type of the object name such as
  # RRULE, EXRULE, or VEVENT
  def name
    @rdatelist.getName
  end
  
  # Sets the type of the object such as
  # RRULE, EXRULE, or VEVENT
  # 
  # ==== Options
  # +new_name+:: 'RRULE', 'EXRULE', or 'VEVENT'
  def name=(new_name)
    @rdatelist.setName(new_name)
    self
  end
  
  # Returns the timezone ID. For instance, the time zone ID for the 
  # U.S. Pacific Time zone is "America/Los_Angeles"
  def zone
    @rdatelist.getTzid.getID
  end
  
  # Sets the timezone using Time zone ID
  def zone=(timezone)
    @rdatelist.setTzid(JTimeZone.getTimeZone(timezone))
    self
  end
  
  # Returns the JTime in UTC time zone
  def utc_dates
    dates = @rdatelist.getDatesUtc
    dates.map do |d|
      JTime.utc(d.year, d.month, d.day)
    end
  end
  
  # Sets the dates. It will convert the dates into UTC.
  def utc_dates=(dates)
    dates = dates.map do |d|
      utc_d = d.utc
      com.google.ical.values.DateValueImpl.new(utc_d.year, utc_d.month, utc_d.day)
    end
    @rdatelist.setDatesUtc(dates.to_java('com.google.ical.values.DateValue'))
    self
  end
end