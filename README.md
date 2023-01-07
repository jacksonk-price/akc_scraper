# breed_scraper

Ruby scripts that use Selenium to collect information on dog breeds from the [American Kennel Club](https://www.akc.org/).

### Prerequisites

You will need Ruby 3+ installed on your system.
- [Ruby 3+](https://www.ruby-lang.org/en/documentation/installation/)

## What does each script do?

### breed_name_scraper.rb
This script collects the name of each breed listed on the [American Kennel Club](https://www.akc.org/) website.

### breed_scraper.rb
This script uses the names collected in breed_name_scraper.rb to gather information from the [American Kennel Club](https://www.akc.org/) such as a description, energy_score, trainability_score, etc. This information is then outputted into a CSV file.
    
## Running the scripts

In your terminal, navigate to your local directory where these scripts are located and run:
    
    
    ruby (script_name_here).rb
 
 ### Example
    
    ruby breed_name_scraper.rb

## To Do

 * Fix issues with some weight values returning zero or containing extra text in collect_breed_weight_method


