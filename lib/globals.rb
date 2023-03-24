module Globals
  require 'logger'

  # Create a Logger that prints to STDOUT
  $LOG = Logger.new(STDOUT)
  $LOG.datetime_format = "%m/%d/%y %H:%M:%S"
  # Create a Logger that prints to STDERR
  $ERROR_LOG = Logger.new(STDERR)

  $OPTIONS = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
  # $DRIVER = Selenium::WebDriver.for(:firefox, options: $OPTIONS)
  $DRIVER = Selenium::WebDriver.for :firefox
  $WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)
end