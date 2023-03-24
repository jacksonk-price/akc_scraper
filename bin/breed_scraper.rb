#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'csv'
require 'colorize'
require "../lib/globals"
require "../lib/breed_names"
require "../lib/dog"
include Globals
include BreedNames

def scrape_it
  $LOG.info("starting scrape...")

  # breed_names = $BREED_NAMES
  breed_names = ["Affenpinscher", "Afghan Hound", "Airedale Terrier"]
  breed_info = collect_breed_info(breed_names)

  $LOG.info("converting to csv...")
  send_to_csv(breed_info)
  $LOG.info("completed conversion")

  $DRIVER.close
end
def collect_breed_info(breed_names)
  breeds = []
  breed_names.each_with_index do |breed_name, index|
    current_breed = Dog.new(breed_name)

    current_breed.navigate

    description = current_breed.collect_breed_description
    scores = current_breed.collect_breed_scores
    weight_hash = current_breed.collect_breed_weight

    $LOG.info("collected all information for #{current_breed.name}")

    current_breed.name = breed_name
    current_breed.description = description
    current_breed.min_weight = weight_hash[:min_weight]
    current_breed.max_weight = weight_hash[:max_weight]
    current_breed.trait_scores = scores

    breeds << current_breed

    $LOG.info("completed #{current_breed.name} | #{percent_completed(index, breed_names.count)}% completed")
  end
  breeds
end

def percent_completed(index, breed_amount)
  percent = (((index.to_f + 1.0) / breed_amount.to_f) * 100.0).to_s
  decimal_index = percent.index('.')
  percent[0, decimal_index]. + percent[decimal_index, (decimal_index + 1)]
end

def send_to_csv(breed_info)
  CSV.open("dog-data.csv", "wb") do |csv|
    headers = %w[name description min_weight max_weight family_score
                  children_score other_dog_score shedding_score grooming_score
                  drooling_score stranger_score playfulness_score protective_score
                  adaptability_score trainability_score energy_score barking_score
                  mental_stim_score]

    csv << headers
    breed_info.each do |breed|
      row = [ breed.name, breed.description, breed.min_weight,
              breed.max_weight, *breed.trait_scores.first(14) ]

      csv << row
    end
  end
end

scrape_it