require 'rubygems'
require 'spec'
require File.dirname(__FILE__) + '/../lib/rfc2445'

describe JTime do
  it "should able to initialize a new JTime with the current time" do
    now = Time.now
    time = JTime.new
    time.should_not be_nil
    time.to_java.getYear.should == now.year
    time.to_java.getDayOfMonth.should == now.day
    time.to_java.getMonthOfYear.should == now.month
    time.to_java.getHourOfDay.should == now.hour
    time.to_java.getMinuteOfHour.should == now.min
    
    time = JTime.now
    time.should_not be_nil
    time.to_java.getYear.should == now.year
    time.to_java.getDayOfMonth.should == now.day
    time.to_java.getMonthOfYear.should == now.month
    time.to_java.getHourOfDay.should == now.hour
    time.to_java.getMinuteOfHour.should == now.min
  end
  
  it "should able to initialize a new JTime with epoch second" do
    now = Time.now
    time = JTime.at(now.to_i)
    time.to_java.getYear.should == now.year
    time.to_java.getDayOfMonth.should == now.day
    time.to_java.getMonthOfYear.should == now.month
    time.to_java.getHourOfDay.should == now.hour
    time.to_java.getMinuteOfHour.should == now.min
  end
  
  it "should able to initialize a new JTime with utc" do
    time = JTime.utc(2000, "dec", 25, 20, 15, 1)
    time.to_java.getYear.should == 2000
    time.to_java.getMonthOfYear.should == 12
    time.to_java.getDayOfMonth.should == 25
    time.to_java.getHourOfDay.should == 20
    time.to_java.getMinuteOfHour.should == 15
  end
  
  it "should able to initialize a new JTime with local" do
    time = JTime.local(2000, "dec", 25, 20, 15, 1)
    time.to_java.getYear.should == 2000
    time.to_java.getMonthOfYear.should == 12
    time.to_java.getDayOfMonth.should == 25
    time.to_java.getHourOfDay.should == 20
    time.to_java.getMinuteOfHour.should == 15
  end
  
  it "should able to initialize a new JTime with DateTimeValue" do
    dtv = com.google.ical.values.DateTimeValueImpl.new(2000, 12, 25, 20, 15, 1)
    time = JTime.from_date_time_value(dtv)
    time.to_java.getYear.should == 2000
    time.to_java.getMonthOfYear.should == 12
    time.to_java.getDayOfMonth.should == 25
    time.to_java.getHourOfDay.should == 20
    time.to_java.getMinuteOfHour.should == 15
  end
  
  it "should able to initialize a new JTime object from Ruby Time" do
    now = Time.now
    jtime = JTime.from_time(now)
    jtime.should be_instance_of(JTime)
    jtime.year.should == now.year
    jtime.month.should == now.month
    jtime.day.should == now.day
    jtime.hour.should == now.hour
    jtime.min.should == now.min
  end
  
  it "should return a Ruby time object" do
    now = Time.now
    time = JTime.new
    rtime = time.to_time
    rtime.should be_instance_of(Time)
    rtime.year.should == now.year
    rtime.month.should == now.month
    rtime.day.should == now.day
    rtime.hour.should == now.hour
    rtime.min.should == now.min
  end
  
  it "should return a Java DateTime object" do
    time = JTime.new
    jtime = time.to_java
    jtime.java_kind_of?(org.joda.time.DateTime).should == true
  end
  
  it "should return a date time value object" do
    time = JTime.new
    dtv = time.to_date_time_value
    dtv.java_kind_of?(com.google.ical.values.DateTimeValueImpl).should == true
  end
  
  it "should able to return a UTC time" do
    time = JTime.now
    utc_time = time.utc
    ruby_utc_time = time.to_time.utc
    utc_time.to_java.getHourOfDay.should == ruby_utc_time.hour
    utc_time.to_java.getMinuteOfHour.should == ruby_utc_time.min
  end
  
  it "should return if dst" do
    time1 = JTime.local(2008, "dec", 25, 20, 15, 1)
    time2 = JTime.local(2008, "jul", 1, 20, 15, 1)    
    time1.dst?.should == false
    time2.isdst.should == true
  end
  
  it "should able to compare with another JTime" do
    time1 = JTime.new
    time2 = JTime.local(2000, "dec", 25, 20, 15, 1)
    (time1 > time2).should == true
    (time1 < time2).should == false
    (time1 == time1).should == true
  end
  
  it "should return the year for time" do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.year.should == 2008
  end
  
  it "should return the month of the year" do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.month.should == 12
    time.mon.should == 12
  end
  
  it "should return the day of the month" do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.day.should == 25
  end
  
  it "should return the hour of the day" do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.hour.should == 20
  end
  
  it "should return the minute of the hour" do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.min.should == 15
  end
  
  it "should return the second of the minute" do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.day.should == 25
  end
  
  it "should return the day of the week"do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.wday.should == 4
  end
  
  it "should return the day of the year"do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.yday.should == 360
  end
  
  it "should return the week number of the year"do
    time = JTime.local(2008, "dec", 25, 20, 15, 1)
    time.week.should == 52
  end
  
  it "should return a value of time as a floating-point number of seconds since epoch" do
    time = JTime.new
    rtime = time.to_time
    time.to_f.should == rtime.to_f
  end
  
  it "should return a value of time as an integer number of seconds since epoch" do
    time = JTime.new
    rtime = time.to_time
    time.to_i.should == rtime.to_i
  end
  
  it "should return a string representing time" do
    time = JTime.new
    time.should respond_to(:to_s)    
  end
  
  it "should return the name of the time zone" do
    # Notice that it is different than the Ruby Time object, it returns the real ID 'America/Los_Angeles' instead of "PST"
    time = JTime.new.utc
    time.should respond_to(:zone)
    time.zone.should == 'UTC'
  end
end

describe RRule do
  before(:each) do
    @rrule = RRule.new
  end
  
  it "should initialize a RRule object with ical string" do
    ical_string = "RRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=13"
    rrule = RRule.new(ical_string)
    rrule.should_not be_nil
  end
  
  it "should return an ical string" do
    ical_string = "RRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=13"
    rrule = RRule.new(ical_string)
    (rrule.to_ical =~ /FREQ=MONTHLY/).should_not be_nil
    (rrule.to_ical =~ /BYDAY=FR/).should_not be_nil
    (rrule.to_ical =~ /BYMONTHDAY=13/).should_not be_nil
    (rrule.to_ical =~ /COUNT=13/).should_not be_nil
  end
  
  it "should return extra parameters" do
    ical_string = "RRULE;X-FOO=BAR:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=13;"
    rrule = RRule.new(ical_string)
    ext_params = rrule.ext_params
    ext_params['X-FOO'].should == 'BAR'
  end
  
  it "should set and get the count" do
    @rrule.count = 13
    @rrule.count.should == 13
  end
  
  it "should set and get the days" do
    wday = WeekdayNum.new(5, 'Fri')
    @rrule.days = [wday]
    (@rrule.days.first == wday).should == true
  end
  
  it "should set and get the hours" do
    @rrule.hours = [1, 13]
    @rrule.hours.include?(1).should == true
    @rrule.hours.include?(13).should == true
  end
  
  it "should set and get the minutes" do
    @rrule.minutes = [1, 13]
    @rrule.minutes.include?(1).should == true
    @rrule.minutes.include?(13).should == true
  end
  
  it "should set and get the monthdays" do
    @rrule.mdays = [1, 13]
    @rrule.mdays.include?(1).should == true
    @rrule.mdays.include?(13).should == true
  end
  
  it "should set and get the seconds" do
    @rrule.seconds = [1, 13]
    @rrule.seconds.include?(1).should == true
    @rrule.seconds.include?(13).should == true
  end
  
  it "should set and get the week numbers" do
    @rrule.weeknums = [1, 13]
    @rrule.weeknums.include?(1).should == true
    @rrule.weeknums.include?(13).should == true
  end
  
  it "should set and get the year days" do
    @rrule.ydays = [1, 360]
    @rrule.ydays.include?(1).should == true
    @rrule.ydays.include?(360).should == true
  end
  
  it "should set and get the frequency" do
    @rrule.frequency = Frequency::MONTHLY
    @rrule.frequency.should == Frequency::MONTHLY
  end
  
  it "should set and get the starting weekday" do
    @rrule.wdaystart = 'Fri'
    @rrule.wdaystart.should == 5
    @rrule.wdaystart = 3
    @rrule.wdaystart.should == 3
  end 
  
  it "should set and get the interval" do
    @rrule.interval = 10
    @rrule.interval.should == 10
  end
  
  it "should set and get the object name, such as RRULE, EXRULE, VEVENT" do
    @rrule.name = RRule::EXRULE
    @rrule.name.should == RRule::EXRULE
  end
  
  it "should set and get the until date" do
    now = JTime.new.utc
    @rrule.until = now
    @rrule.until.year.should == now.year
    @rrule.until.month.should == now.month
    @rrule.until.day.should == now.day
    @rrule.until.hour.should == now.hour
    @rrule.until.min.should == now.min
    @rrule.until.sec.should == now.sec
  end
end

describe RDateList do
  before(:each) do
    @rdatelist = RDateList.new
  end
  
  it "should initialize a RDateList object with no params" do
    @rdatelist.should_not be_nil
  end
  
  it "should initialize a RDatelist object with a timezone" do
    rdatelist = RDateList.new('UTC')
    @rdatelist.should_not be_nil
  end
  
  it "should initialize a RDateList object with ical string" do
    ical_string = "RDATE:19960402T010000,19960403T010000,19960404T010000"
    rdatelist = RDateList.new(nil, ical_string)
    rdatelist.should_not be_nil
  end
  
  it "should return an ical string" do
    ical_string = "RDATE:19960402T010000,19960403T010000,19960404T010000"
    rdatelist = RDateList.new(nil, ical_string)
    (rdatelist.to_ical =~ /TZID=/).should_not be_nil
    (rdatelist.to_ical =~ /VALUE=DATE-TIME:/).should_not be_nil
    (rdatelist.to_ical =~ /19960402/).should_not be_nil
    (rdatelist.to_ical =~ /19960403/).should_not be_nil
    (rdatelist.to_ical =~ /19960404/).should_not be_nil
  end
  
  it "should return extra parameters" do
    ical_string = "RDATE;X-FOO=BAR:19960402T010000,19960403T010000,19960404T010000"
    rdatelist = RDateList.new(nil, ical_string)
    ext_params = rdatelist.ext_params
    ext_params['X-FOO'].should == 'BAR'
  end
  
  it "should set and get the object name, such as RRULE, EXRULE, VEVENT" do
    @rdatelist.name = RRule::EXRULE
    @rdatelist.name.should == RRule::EXRULE
  end
  
  it "should set and get timezone" do
    @rdatelist.zone = 'UTC'
    @rdatelist.zone.should == 'UTC'
  end
  
  it "should set array of utc dates and get array of utc dates" do
    utc_date = JTime.utc(2008, 12, 25)
    @rdatelist.utc_dates = [utc_date]
    @rdatelist.utc_dates.first.year.should == 2008
    @rdatelist.utc_dates.first.month.should == 12
    @rdatelist.utc_dates.first.day.should == 25    
  end
end

describe ICalParseUtil do
  it "should parse an ical string and timezone to a date time value" do
    dtv = ICalParseUtil.parse_date_value('20090327T180000', 'America/Los_Angeles')
    dtv.java_kind_of?(com.google.ical.values.DateTimeValueImpl).should == true
    dtv.hour.should == 1
    dtv.day.should == 28
  end
  
  it "should return nil if passing nil to parse_date_value" do
    dtv = ICalParseUtil.parse_date_value(nil)
    dtv.should be_nil
  end
  
  it "should parse an ical string and timezone to a JTime object" do
    jtime = ICalParseUtil.parse_jtime('20090327T180000', 'America/Los_Angeles')
    jtime.should be_instance_of(JTime)
    jtime.hour.should == 1
    jtime.day.should == 28
  end
  
  it "should return nil if passing nil to parse_jtime" do
    jtime = ICalParseUtil.parse_jtime(nil)
    jtime.should be_nil
  end
  
  it "should parse a recurrence block" do
    string = <<-end_src
    DTSTART;TZID=America/Los_Angeles:20090320T170000
    DTEND;TZID=America/Los_Angeles:20090320T180000
    RRULE:FREQ=WEEKLY;BYDAY=FR;WKST=SU
    EXRULE:FREQ=MONTHLY;BYDAY=1FR
    RDATE;TZID=America/Los_Angeles:20090321T170000
    BEGIN:VTIMEZONE
    TZID:America/Los_Angeles
    X-LIC-LOCATION:America/Los_Angeles
    BEGIN:DAYLIGHT
    TZOFFSETFROM:-0800
    TZOFFSETTO:-0700
    TZNAME:PDT
    DTSTART:19700308T020000
    RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU
    END:DAYLIGHT
    BEGIN:STANDARD
    TZOFFSETFROM:-0700
    TZOFFSETTO:-0800
    TZNAME:PST
    DTSTART:19701101T020000
    RRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU
    END:STANDARD
    END:VTIMEZONE
    end_src
    
    r = ICalParseUtil.parse_recurrence(string)
    r[:dtstart].should == "DTSTART;TZID=America/Los_Angeles:20090320T170000"
    r[:dtend].should == "DTEND;TZID=America/Los_Angeles:20090320T180000"
    r[:rrule].should == "RRULE:FREQ=WEEKLY;BYDAY=FR;WKST=SU"
    r[:exrule].should == "EXRULE:FREQ=MONTHLY;BYDAY=1FR"
    r[:rdate].should == "RDATE;TZID=America/Los_Angeles:20090321T170000"
    r[:exdate].should == nil
  end
  
  it "should parse datetime into JTime" do
    jtime1 = ICalParseUtil.parse_datetime('DTSTART;TZID=America/Los_Angeles:20090320T170000')
    jtime1.should be_instance_of(JTime)
    jtime1.hour.should == 0
    
    jtime2 = ICalParseUtil.parse_datetime('DTEND;TZID=America/Los_Angeles:20090320T180000')
    jtime2.should be_instance_of(JTime)
    jtime2.hour.should == 1
    
    jtime3 = ICalParseUtil.parse_datetime(nil)
    jtime3.should be_nil
  end
  
  it "should parse date into JTime" do
    jtime = ICalParseUtil.parse_datetime('DTSTART;VALUE=DATE:20100129')
    jtime.should be_instance_of(JTime)
    jtime.hour.should == 0
  end
  
  it "should parse recurrence-id into JTime" do
    jtime = ICalParseUtil.parse_recurrence_id('2010-02-11T02:00:00Z')
    jtime.should == JTime.utc(2010, 2, 11, 2)
    
    jtime = ICalParseUtil.parse_recurrence_id(';VALUE=DATE:20100211')
    jtime.should == JTime.utc(2010, 2, 11)
    
    jtime = ICalParseUtil.parse_recurrence_id(';VALUE=DATE-TIME:20100211T020000Z')
    jtime.should == JTime.utc(2010, 2, 11, 2)
    
    jtime = ICalParseUtil.parse_recurrence_id(';VALUE=DATE-TIME:2010-02-11T02:00:00Z')
    jtime.should == JTime.utc(2010, 2, 11, 2)
    
    jtime = ICalParseUtil.parse_recurrence_id(';TZID=America/Los_Angeles;VALUE=DATE:20100211')
    jtime.should == JTime.utc(2010, 2, 11, 8)
  end
end

describe RecurrenceTime do
  before(:each) do
    @ical_string = "RRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=13"
    @start_date = JTime.local(2001, 4, 13)
    @rtime = RecurrenceTime.new(@ical_string, @start_date)
  end
  
  it "should be initialized by RRule object" do
    rrule = RRule.new(@ical_string)
    rtime = RecurrenceTime.new(rrule, @start_date)
    rtime.should be_instance_of(RecurrenceTime)
  end
  
  it "should be initialized by an array of RRules" do
    rrule1 = RRule.new(@ical_string)
    # The first date is excluded
    rrule2 = RRule.new("EXRULE:FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=1")
    rtime = RecurrenceTime.new([rrule1, rrule2], @start_date)
    rtime.should be_instance_of(RecurrenceTime)
    rtime.next.should > @start_date
  end
  
  it "should initialized by an array of RRules and RDateLists" do
    rrule = RRule.new(@ical_string)
    rdatelist = RDateList.new
    rdatelist.utc_dates = [JTime.utc(2001, 4, 14)]
    rtime = RecurrenceTime.new([rdatelist, rrule], @start_date)
    rtime.should be_instance_of(RecurrenceTime)
    rtime.next
    first_next = rtime.next
    first_next.mon.should == 4
    first_next.day.should == 14
    first_next.year.should == 2001
  end
  
  it "should able to generate a JTime by invoking next" do
    nexttime = @rtime.next
    nexttime.should be_instance_of(JTime)
    (nexttime <=> @start_date).should == 0
  end
  
  it "should able to advance to a specific date" do
    # It skips 2 dates 4/13 and 7/13
    @rtime.advance_to(JTime.utc(2001, 7, 15))
    third_next = @rtime.next
    third_next.mon.should == 9
    third_next.day.should == 13
    third_next.year.should == 2002
  end
  
  it "should return true if there is more time for the recurrence time" do
    13.times do
      @rtime.has_next?.should == true
      @rtime.next
    end
    @rtime.has_next?.should == false
  end
  
  it "should return the java iterator" do
    @rtime.to_java.java_kind_of?(com.google.ical.compat.jodatime.DateTimeIterator).should == true
  end
  
  it "should able to iterate" do
    i = 0
    @rtime.each do |t|
      i += 1
      t.should be_instance_of(JTime)
    end
    i.should == 13
  end
end