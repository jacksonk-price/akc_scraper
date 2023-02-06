#!/usr/bin/env ruby
require "selenium-webdriver"
require_relative "../lib/globals"
include Globals

def scrape_it
  names = []
  letters = ('A'..'Y').to_a
  letters.each do |letter|
    $DRIVER.navigate.to("https://www.akc.org/dog-breeds/?letter=#{letter}")
    puts '-' * 50
    puts "navigating to https://www.akc.org/dog-breeds/?letter=#{letter}"
    puts '-' * 50
    $WAIT.until {
      $DRIVER.find_element(:class, 'resources-billboard__text')
    }
    while load_more_btn_exists? do
      $DRIVER.find_element(:id, 'load-more-btn').click
      puts 'load more clicked...'
    end

    sleep 3
    puts "starting name grab for category #{letter}..."
    $DRIVER.find_elements(:class, 'breed-type-card__title').each do |title|
      puts "grabbing name #{title.text}"
      names << title.text
    end
  end


  puts names.inspect
  puts '-' * 50
  puts "#{names.count} total names collected"
  puts '-' * 50
  $DRIVER.close
end
def load_more_btn_exists?
  begin
    true if $DRIVER.find_element(:id, 'load-more-btn')
  rescue => e
    false
  end
end

scrape_it
