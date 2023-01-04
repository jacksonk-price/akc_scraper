#!/usr/bin/env ruby
require 'selenium-webdriver'
require 'csv'

$OPTIONS = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
# $DRIVER = Selenium::WebDriver.for(:firefox, options: $OPTIONS)
$DRIVER = Selenium::WebDriver.for :firefox
$WAIT = Selenium::WebDriver::Wait.new(:timeout => 60)
$BREED_NAMES = ["Affenpinscher", "Afghan Hound", "Airedale Terrier", "Akita", "Alaskan Klee Kai", "Alaskan Malamute", "American Bulldog", "American English Coonhound",
                "American Eskimo Dog", "American Foxhound", "American Hairless Terrier", "American Leopard Hound", "American Staffordshire Terrier", "American Water Spaniel",
                "Anatolian Shepherd Dog", "Appenzeller Sennenhund", "Australian Cattle Dog", "Australian Kelpie", "Australian Shepherd", "Australian Stumpy Tail Cattle Dog",
                "Australian Terrier", "Azawakh", "Barbado da Terceira", "Barbet", "Basenji", "Basset Fauve de Bretagne", "Basset Hound", "Bavarian Mountain Scent Hound", "Beagle",
                "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Laekenois", "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bergamasco Sheepdog",
                "Berger Picard", "Bernese Mountain Dog", "Bichon Frise", "Biewer Terrier", "Black and Tan Coonhound", "Black Russian Terrier", "Bloodhound", "Bluetick Coonhound",
                "Boerboel", "Bohemian Shepherd", "Bolognese", "Border Collie", "Border Terrier", "Borzoi", "Boston Terrier", "Bouvier des Flandres", "Boxer", "Boykin Spaniel",
                "Bracco Italiano", "Braque du Bourbonnais", "Braque Francais Pyrenean", "Briard", "Brittany", "Broholmer", "Brussels Griffon", "Bull Terrier", "Bulldog", "Bullmastiff",
                "Cairn Terrier", "Canaan Dog", "Cane Corso", "Cardigan Welsh Corgi", "Carolina Dog", "Catahoula Leopard Dog", "Caucasian Shepherd Dog", "Cavalier King Charles Spaniel",
                "Central Asian Shepherd Dog", "Cesky Terrier", "Chesapeake Bay Retriever", "Chihuahua", "Chinese Crested", "Chinese Shar-Pei", "Chinook", "Chow Chow", "Cirneco dell’Etna",
                "Clumber Spaniel", "Cocker Spaniel", "Collie", "Coton de Tulear", "Croatian Sheepdog", "Curly-Coated Retriever", "Czechoslovakian Vlcak", "Dachshund", "Dalmatian",
                "Dandie Dinmont Terrier", "Danish-Swedish Farmdog", "Deutscher Wachtelhund", "Doberman Pinscher", "Dogo Argentino", "Dogue de Bordeaux", "Drentsche Patrijshond", "Drever",
                "Dutch Shepherd", "English Cocker Spaniel", "English Foxhound", "English Setter", "English Springer Spaniel", "English Toy Spaniel", "Entlebucher Mountain Dog",
                "Estrela Mountain Dog", "Eurasier", "Field Spaniel", "Finnish Lapphund", "Finnish Spitz", "Flat-Coated Retriever", "French Bulldog", "French Spaniel",
                "German Longhaired Pointer", "German Pinscher", "German Shepherd Dog", "German Shorthaired Pointer", "German Spitz", "German Wirehaired Pointer", "Giant Schnauzer",
                "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Grand Basset Griffon Vendéen", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain Dog", "Greyhound",
                "Hamiltonstovare", "Hanoverian Scenthound", "Harrier", "Havanese", "Hokkaido", "Hovawart", "Ibizan Hound", "Icelandic Sheepdog", "Irish Red and White Setter",
                "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Italian Greyhound", "Jagdterrier", "Japanese Akitainu", "Japanese Chin", "Japanese Spitz",
                "Japanese Terrier", "Jindo", "Kai Ken", "Karelian Bear Dog", "Keeshond", "Kerry Blue Terrier", "Kishu Ken", "Komondor", "Kromfohrlander", "Kuvasz", "Labrador Retriever",
                "Lagotto Romagnolo", "Lakeland Terrier", "Lancashire Heeler", "Lapponian Herder", "Leonberger", "Lhasa Apso", "Löwchen", "Maltese", "Manchester Terrier (Standard)",
                "Manchester Terrier (Toy)", "Mastiff", "Miniature American Shepherd", "Miniature Bull Terrier", "Miniature Pinscher", "Miniature Schnauzer", "Mountain Cur", "Mudi",
                "Neapolitan Mastiff", "Nederlandse Kooikerhondje", "Newfoundland", "Norfolk Terrier", "Norrbottenspets", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund",
                "Norwich Terrier", "Nova Scotia Duck Tolling Retriever", "Old English Sheepdog", "Otterhound", "Papillon", "Parson Russell Terrier", "Pekingese", "Pembroke Welsh Corgi",
                "Perro de Presa Canario", "Peruvian Inca Orchid", "Petit Basset Griffon Vendéen", "Pharaoh Hound", "Plott Hound", "Pointer", "Polish Lowland Sheepdog", "Pomeranian",
                "Poodle (Miniature)", "Poodle (Standard)", "Poodle (Toy)", "Porcelaine", "Portuguese Podengo", "Portuguese Podengo Pequeno", "Portuguese Pointer", "Portuguese Sheepdog",
                "Portuguese Water Dog", "Pudelpointer", "Pug", "Puli", "Pumi", "Pyrenean Mastiff", "Pyrenean Shepherd", "Rafeiro do Alentejo", "Rat Terrier", "Redbone Coonhound",
                "Rhodesian Ridgeback", "Romanian Carpathian Shepherd", "Romanian Mioritic Shepherd Dog", "Rottweiler", "Russell Terrier", "Russian Toy", "Russian Tsvetnaya Bolonka",
                "Saint Bernard", "Saluki", "Samoyed", "Schapendoes", "Schipperke", "Scottish Deerhound", "Scottish Terrier", "Sealyham Terrier", "Segugio Italiano", "Shetland Sheepdog",
                "Shiba Inu", "Shih Tzu", "Shikoku", "Siberian Husky", "Silky Terrier", "Skye Terrier", "Sloughi", "Slovakian Wirehaired Pointer", "Slovensky Cuvac", "Slovensky Kopov",
                "Small Munsterlander", "Smooth Fox Terrier", "Soft Coated Wheaten Terrier", "Spanish Mastiff", "Spanish Water Dog", "Spinone Italiano", "Stabyhoun",
                "Staffordshire Bull Terrier", "Standard Schnauzer", "Sussex Spaniel", "Swedish Lapphund", "Swedish Vallhund", "Taiwan Dog", "Teddy Roosevelt Terrier", "Thai Ridgeback",
                "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Tornjak", "Tosa", "Toy Fox Terrier", "Transylvanian Hound", "Treeing Tennessee Brindle", "Treeing Walker Coonhound",
                "Vizsla", "Volpino Italiano", "Weimaraner", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier", "Wetterhoun", "Whippet", "Wire Fox Terrier",
                "Wirehaired Pointing Griffon", "Wirehaired Vizsla", "Working Kelpie", "Xoloitzcuintli", "Yakutian Laika", "Yorkshire Terrier"]

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
        puts "waiting on #{formatted_name}..."
      end
    }
    print "collecting data for #{formatted_name}..."
    scores = collect_breed_scores
    breed_hash[breed] = {
      name: breed,
      description: collect_breed_description,
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
    puts "success...(#{percent_completed(index, breed_names.count)}% completed)"
  end
  breed_hash
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