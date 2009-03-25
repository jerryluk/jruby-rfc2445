require 'java'
require File.dirname(__FILE__) + '/rfc2445.jar'

class Weekday
  include_class('com.google.ical.values.Weekday') {|package,name| "J#{name}" }
  MAP = {
    '0' => JWeekday::SU, 'sun' => JWeekday::SU, 'su' => JWeekday::SU,
    '1' => JWeekday::MO, 'mon' => JWeekday::MO, 'mo' => JWeekday::MO,
    '2' => JWeekday::TU, 'tue' => JWeekday::TU, 'tu' => JWeekday::TU,
    '3' => JWeekday::WE, 'wed' => JWeekday::WE, 'we' => JWeekday::WE,
    '4' => JWeekday::TH, 'thu' => JWeekday::TH, 'th' => JWeekday::TH,
    '5' => JWeekday::FR, 'fri' => JWeekday::FR, 'fr' => JWeekday::FR,
    '6' => JWeekday::SA, 'sat' => JWeekday::SA, 'sa' => JWeekday::SA,
    JWeekday::SU => 0,
    JWeekday::MO => 1,
    JWeekday::TU => 2,
    JWeekday::WE => 3,
    JWeekday::TH => 4,
    JWeekday::FR => 5,
    JWeekday::SA => 6,
  }
  
end