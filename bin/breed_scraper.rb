#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'csv'
require 'colorize'
require "../lib/globals"
require "../lib/breed_names"
include Globals
include BreedNames

def scrape_it
  puts '=' * 50
  puts 'starting scrape...'
  puts '=' * 50

  breed_names = $BREED_NAMES
  breed_info = collect_breed_info(breed_names)

  puts '=' * 50
  print 'converting data to csv...'
  send_to_csv(breed_info)
  puts 'complete'
  puts '=' * 50
  $DRIVER.close
end
def collect_breed_info(breed_names)
  breed_hash = { }
  breed_names.each_with_index do |breed, index|
    formatted_name = format_name(breed)
    url = "https://www.akc.org/dog-breeds/#{formatted_name}/"
    $DRIVER.navigate.to(url)
    $WAIT.until {
      begin
        $DRIVER.find_element(:class, 'breed-page__about__read-more__text__less')
      rescue
        print '[INFO] '.blue
        puts "waiting on #{formatted_name}..."
      end
    }
    print '[INFO] '.blue
    scores = collect_breed_scores
    puts "collected score values for #{formatted_name}..."
    weight_hash = collect_breed_weight
    print '[INFO] '.blue
    puts "collected weight values for #{formatted_name}..."
    breed_hash[breed] = {
      name: breed,
      description: collect_breed_description,
      min_weight: weight_hash[:min_weight],
      max_weight: weight_hash[:max_weight],
      family_score: scores[:family_score],
      children_score: scores[:children_score],
      other_dog_score: scores[:other_dog_score],
      shedding_score: scores[:shedding_score],
      grooming_score: scores[:grooming_score],
      drooling_score: scores[:drooling_score],
      stranger_score: scores[:stranger_score],
      playfulness_score: scores[:playfulness_score],
      protective_score: scores[:protective_score],
      adaptability_score: scores[:adaptability_score],
      trainability_score: scores[:trainability_score],
      energy_score: scores[:energy_score],
      barking_score: scores[:barking_score],
      mental_stim_score: scores[:mental_stim_score]
    }
    print '[SUCCESS] '.green
    puts "completed #{formatted_name} #{percent_completed(index, breed_names.count)}% completed)"
  end
  breed_hash
end
def percent_completed(index, breed_amount)
  percent = (((index.to_f + 1.0) / breed_amount.to_f) * 100.0).to_s
  decimal_index = percent.index('.')
  percent[0, decimal_index]. + percent[decimal_index, (decimal_index + 1)]
end
def collect_breed_description
  sleep 1
  $DRIVER.find_element(:class, 'breed-page__about__read-more__text').text
end
def collect_breed_scores
  score_hash = Hash.new
  $DRIVER.find_element(:id, 'breed-page__traits__all').find_elements(:class, 'breed-trait-score__score-wrap').each_with_index do |d, index|
    score_hash[get_key(index).to_sym] = d.find_elements(:class, 'breed-trait-score__score-unit--filled').count
  end
  score_hash
end
def collect_breed_weight
  sleep 2
  weight_hash = Hash.new
  elems_arr = $DRIVER.find_elements(:class, 'breed-page__hero__overview__subtitle').map { |e| e.text }
  weight_elems = elems_arr.select { |e| e.include? 'pounds' or e.include? 'lbs' }
  # plz rewrite this
  case weight_elems.count
  when 1
    if weight_elems[0].include? 'pounds' # example => ["45- 70 pounds"]
      weight_text = remove_whitespace(weight_elems[0]).gsub('pounds', '') # remove whitespace and pounds => ["45-70"]
      split_weight_text = weight_text.split('-') # split at hyphen => ["45", "70"]
      weight_hash[:min_weight] = split_weight_text[0] # store in hash for min => "45"
      weight_hash[:max_weight] = split_weight_text[1] # store hash for max => "70"
    elsif weight_elems[0].include? 'lbs' # example => ["45- 70 lbs"]
      weight_text = remove_whitespace(weight_elems[0]).gsub('lbs', '') # remove whitespace and lbs => ["45-70"]
      split_weight_text = weight_text.split('-') # split at hyphen => ["45", "70"]
      weight_hash[:min_weight] = split_weight_text[0] # store in hash for min => "45"
      weight_hash[:max_weight] = split_weight_text[1] # store in hash for max => "70"
    end
  when 2
    if weight_elems[0].include? 'pounds' # example => ["45- 70 pounds (male)", "25- 55 pounds (female)"]
      if weight_elems[0].include? 'under'
           weight_text = remove_whitespace(weight_elems[1])
           split_weight_text = weight_text.split('-')
           weight_hash[:min_weight] = split_weight_text[0]
           weight_hash[:max_weight] = split_weight_text[1].split('p')[0]
      else
        male_weight_text = remove_whitespace(weight_elems[0]) # remove whitespace for male value => ["45-70pounds(male)"]
        if male_weight_text.include? '-'
          split_male_weight_text = male_weight_text.split('-') # split values => ["70", "130pounds(male)"]
          max_male_weight = split_male_weight_text[1].split('p')[0] # split max val at the p and select first elem=> ["130"]
        else
          max_male_weight = male_weight_text.split('p')[0]
        end
        female_weight_text = remove_whitespace(weight_elems[1])
        if female_weight_text.include? '-'
          min_female_weight = female_weight_text.split('-')[0]
        else
          min_female_weight = female_weight_text.split('p')[0]
        end
        weight_hash[:min_weight] = min_female_weight
        weight_hash[:max_weight] = max_male_weight
      end
    elsif weight_elems[0].include? 'lbs'
      male_weight_text = remove_whitespace(weight_elems[0])
      if male_weight_text.include? '-'
        split_male_weight_text = male_weight_text.split('-') # => ["70", "130pounds"]
        max_male_weight = split_male_weight_text[1].to_s.split('l')[0]
      else
        max_male_weight = male_weight_text.split('l')[0]
      end
      female_weight_text = remove_whitespace(weight_elems[1])
      if female_weight_text.include? '-'
        min_female_weight = female_weight_text.split('-')[0]
      else
        min_female_weight = female_weight_text.split('l')[0]
      end
      weight_hash[:min_weight] = min_female_weight
      weight_hash[:max_weight] = max_male_weight
    end
  when 3
    weight_text = remove_whitespace(weight_elems[2])
    weight_hash[:min_weight] = weight_text.split('-')[0]
    weight_hash[:max_weight] = weight_text.split('-')[1].split('p')[0]
  else
    puts weight_elems.count
    puts 'we have an issue inside the case statement'
  end
  weight_hash
end
def get_key(index)
  case index
  when 0
    'family_score'
  when 1
    'children_score'
  when 2
    'other_dog_score'
  when 3
    'shedding_score'
  when 4
    'grooming_score'
  when 5
    'drooling_score'
  when 6
    'stranger_score'
  when 7
    'playfulness_score'
  when 8
    'protective_score'
  when 9
    'adaptability_score'
  when 10
    'trainability_score'
  when 11
    'energy_score'
  when 12
    'barking_score'
  when 13
    'mental_stim_score'
  else
    'error'
  end
end

def format_name(breed)
  breed.unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(' ','-')
end

def remove_whitespace(string)
  string.delete(' ')
end

def text_before_plus(string)
  string.gsub(/\s.+/, '+')
end

def send_to_csv(breed_info)
  CSV.open("dog-data.csv", "wb") do |csv|
    csv << breed_info.first[1].keys
    breed_info.each do |k, v|
      csv << v.values
    end
  end
end

scrape_it