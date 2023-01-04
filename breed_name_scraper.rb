#!/usr/bin/env ruby
require "selenium-webdriver"

letters = ('A'..'Y').to_a
driver = Selenium::WebDriver.for :firefox
names = []

letters.each do |letter|
  driver.navigate.to("https://www.akc.org/dog-breeds/?letter=#{letter}")
  puts '-' * 50
  puts "navigating to https://www.akc.org/dog-breeds/?letter=#{letter}"
  puts '-' * 50
  wait = Selenium::WebDriver::Wait.new(:timeout => 20)
end