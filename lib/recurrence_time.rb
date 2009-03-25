require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class RecurrenceTime
  include Enumerable
  include_class('com.google.ical.compat.jodatime.DateTimeIteratorFactory')
  
  # Initializes a RecurrenceTime objects which generates JTime based on 
  # recurrence rule
  # 
  # ==== Options
  # +rdata+:: it can be one of the following:
  #           1. RRULE, EXRULE, RDATE, and EXDATE lines (RFC 2445 content strings)
  #           2. RRule or RDateList object
  #           3. Array of RRule and RDateList objects, which can be a combinations of 
  #              RRULE and EXRULE
  # +start_time+:: Optional. Start time of the recurrence time. The default is now 
  # +strict+:: Optional. Any failure to parse should result in a ParseException
  #            false causes bad content lines to be logged and ignored. Default is true
  # 
  def initialize(rdata, start_time=JTime.new, strict=true)
    rdata = rdata.to_ical if (rdata.kind_of? RRule or
                              rdata.kind_of? RDateList)
    rdata = (rdata.map {|r| r.to_ical}).join("\n") if rdata.kind_of? Array
    @iterator = DateTimeIteratorFactory.createDateTimeIterator(rdata, 
                start_time.to_java, 
                start_time.java_zone,
                strict)
    self
  end
  
  # Returns a JTime for the instance of next recurrence time
  def next
    @iterator.hasNext ? JTime.new(@iterator.next) : nil
  end
  
  # Skips all dates in the series before the given date. 
  # 
  # ==== Options
  # +new_start_time+:: JTime which the iterator is advanced to.
  # 
  def advance_to(new_start_time)
    @iterator.advanceTo(new_start_time.to_java)
    self
  end
  
  def has_next?
    @iterator.hasNext
  end
  
  def to_java
    @iterator
  end
  
  def each
    yield self.next until self.has_next? == false
  end
end