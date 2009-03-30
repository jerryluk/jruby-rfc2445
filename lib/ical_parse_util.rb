require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class ICalParseUtil
  include_class('com.google.ical.values.IcalParseUtil'){|package,name| "J#{name}" }
  
  # Class Methods
  class << self
    def parse_date_value(s, tzid = 'UTC')
      timezone = java.util.TimeZone.getTimeZone(tzid || 'UTC')
      s ? JIcalParseUtil.parseDateValue(s, timezone) : nil
    end
    
    def parse_jtime(s, tzid = 'UTC')
      s ? JTime.from_date_time_value(parse_date_value(s, tzid || 'UTC')) : nil
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