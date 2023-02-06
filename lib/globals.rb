module Globals
  $OPTIONS = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
  # $DRIVER = Selenium::WebDriver.for(:firefox, options: $OPTIONS)
  $DRIVER = Selenium::WebDriver.for :firefox
  $WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)
end