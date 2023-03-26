class Dog
  require_relative 'globals'

  attr_accessor :name, :description, :min_weight, :max_weight, :trait_scores
  def initialize(name=nil, description=nil, min_weight=nil, max_weight=nil, trait_scores=nil)
    @name = name
    @description = description
    @min_weight = min_weight
    @max_weight = max_weight
    @trait_scores = trait_scores
  end

  def navigate
    url = "https://www.akc.org/dog-breeds/#{format_name}/"
    $DRIVER.navigate.to(url)
    $WAIT.until {
      begin
        $DRIVER.find_element(:class, 'breed-page__about__read-more__text__less')
      rescue
        puts "waiting on #{@name}..."
        $LOG.info("waiting on #{@name}")
      end
    }
  end

  def collect_breed_description
    sleep 1
    $DRIVER.find_element(:class, 'breed-page__about__read-more__text').text
  end

  def collect_breed_scores
    scores = []
    $DRIVER.find_element(:id, 'breed-page__traits__all').find_elements(:class, 'breed-trait-score__score-wrap').each do |score_div|
      scores << score_div.find_elements(:class, 'breed-trait-score__score-unit--filled').count
    end
    scores
  end

  def collect_breed_weight
    sleep 2
    weight_hash = Hash.new
    elems_arr = $DRIVER.find_elements(:class, 'breed-page__hero__overview__subtitle').map { |e| e.text }
    weight_elems = elems_arr.select { |e| e.include? 'pounds' or e.include? 'lbs' }
    pattern = /(\d+)\s*(?:-|to)?\s*(\d+)?\s*(?:pounds|lbs)?/
    case weight_elems.count
    when 1
      text = weight_elems[0]
      if text.match(pattern)
        weight_hash[:min_weight] = $1.to_i
        weight_hash[:max_weight] = $2.to_i
      end
    when 2
      female_text = weight_elems[1]
      puts female_text.match(pattern).inspect
      if female_text.match(pattern)
        if $2.nil?
          female_min = $1.to_i
        else
          female_min = [$1.to_i, $2.to_i].min
        end
        weight_hash[:min_weight] = female_min
      end

      male_text = weight_elems[0]
      puts male_text.match(pattern).inspect
      if male_text.match(pattern)
        if $2.nil?
          male_max = $1.to_i
        else
          male_max = [$1.to_i, $2.to_i].max
        end
        weight_hash[:max_weight] = male_max
      end

      weight_hash
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

  private

  def format_name
    @name.unicode_normalize(:nfkd).encode('ASCII', replace: '').downcase.gsub(' ','-') unless name.nil?
  end

  def remove_whitespace(string)
    string.delete(' ')
  end

  def text_before_plus(string)
    string.gsub(/\s.+/, '+')
  end
end