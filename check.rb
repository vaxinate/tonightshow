require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'pry'
require 'ruby-notify-my-android'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.app_host = 'http://www.showclix.com'

class Checker
  include Capybara::DSL
  def test (month, day)
    visit('/event/thetonightshowstarringjimmyfallon')

    while true
      begin
        page.find('.ui-datepicker-next').click
      rescue
        page.all('.has_event_style1').each do |el|
          return true if el.has_text?(day)
        end

        return false
      end
    end
  end
end


month = ARGV[0]
day = ARGV[1]
check = Checker.new.test(month, day)
puts check

if check
  NMA.notify do |n|
    n.apikey = "785b2a985acac91a457b22f7e41743fa122a5c124909b5d8"
    n.priority = NMA::Priority::HIGH
    n.application = "tonightshow"
    n.event = "TICKETS AVAILABLE FOR #{month.upcase} #{day}"
    n.description = "http://www.showclix.com/event/thetonightshowstarringjimmyfallon"
  end
end
