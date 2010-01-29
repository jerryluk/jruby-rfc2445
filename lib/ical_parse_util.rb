require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class ICalParseUtil
  include_class('com.google.ical.values.IcalParseUtil'){|package,name| "J#{name}" }
  include_class('com.google.ical.values.DateTimeValue')
  include_class('com.google.ical.values.DateValue')
  
  # Class Methods
  class << self
    def parse_date_value(s, tzid = 'UTC')
      timezone = java.util.TimeZone.get_time_zone(tzid || 'UTC')
      s ? JIcalParseUtil.parse_date_value(s, timezone) : nil
    end
    
    def parse_jtime(s, tzid = 'UTC')
      return nil unless s
      value = parse_date_value(s, tzid)
      case value
      when DateTimeValue
        JTime.from_date_time_value(value)
      when DateValue
        timezone = org.joda.time.DateTimeZone.forID(tzid)
        JTime.from_date_value(value, timezone)
      end
    end
    
    # Parse a recurrence block and returns DTSTART, DTEND, RRULE, EXRULE, RDATE, and EXDATE
    def parse_recurrence(s)
      result = {}
      
      # Strip out all the begin..end blocks
      s = s.gsub(/BEGIN.*END[^\s]+/m, '')
      
      s =~ /(DTSTART[^\s]+)/
      result[:dtstart] = $1 if $1
      
      s =~ /(DTEND[^\s]+)/
      result[:dtend] = $1 if $1
      
      s =~ /(RRULE[^\s]+)/
      result[:rrule] = $1 if $1
      
      s =~ /(EXRULE[^\s]+)/
      result[:exrule] = $1 if $1
      
      s =~ /(RDATE[^\s]+)/
      result[:rdate] = $1 if $1
      
      s =~ /(EXDATE[^\s]+)/
      result[:exdate] = $1 if $1
      
      result
    end
    
    def parse_datetime(s)
      s =~ /(;TZID=([^\s]+))?:([^\s]+)/
      parse_jtime($3, $2)
    end
  end
end