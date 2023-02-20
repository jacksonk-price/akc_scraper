# akc_scraper

Ruby scripts that use Selenium to collect information on 280+ dog breeds from the [American Kennel Club](https://www.akc.org/).

## What does each script do?

### breed_name_scraper.rb
This script collects the name of each breed listed on the [American Kennel Club](https://www.akc.org/) website.

### breed_scraper.rb
This script uses the names collected in breed_name_scraper.rb to gather information from the [American Kennel Club](https://www.akc.org/) such as a description, energy_score, trainability_score, etc. This information is then outputted into a CSV file.
    
## Data
You can view and download the data that was collected [here](https://github.com/jacksonk-price/akc_scraper/blob/master/output/dogs.csv).

## To Do

 * Fix issues with some weight values returning zero or containing extra text in collect_breed_weight method
 * Refactor collect_breed_weight method


