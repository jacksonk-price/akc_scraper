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
  
  while true do
    begin
      driver.find_element(:id, 'load-more-btn').click
      puts 'load more clicked...'
    rescue => e
      sleep 3
      puts "starting name grab for category #{letter}..."
      driver.find_elements(:class, 'breed-type-card__title').each do |title|
        puts "grabbing name #{title.text}"
        names << title.text
      end
      break
    end
  end
end