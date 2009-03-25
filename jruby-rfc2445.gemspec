#! /usr/bin/env jruby

spec = Gem::Specification.new do |s| 
  s.name = 'jruby-rfc2445' 
  s.version = '0.0.1' 
  s.authors = ['Jerry Luk']
  s.email = 'jerryluk@gmail.com'
  s.date = '2009-03-24'
  s.summary = 'A JRuby implementation of RFC 2445 (ical) recurrence rule'
  s.description = s.summary
  s.homepage = 'http://www.linkedin.com/in/jerryluk'
  s.require_path = 'lib'
  s.files = ["README", "MIT-LICENSE", "lib/ical_parse_util.jar", "lib/jtime.rb", "lib/rdate_list.rb", "lib/recurrence_time.jar", "lib/rfc2445.rb", "lib/rfc2445.rb", "lib/rrule.rb", "weekday.rb", "weekday_num.rb", "spec/rfc2445_spec.rb"]
  s.test_files = ["spec/rfc2445_spec.rb"]
  s.has_rdoc = false
end