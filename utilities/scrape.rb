require 'nokogiri'
require 'json'
require 'open-uri'

class TripReportScraper
  def initialize(trip_number)
    @number = trip_number 
    @doc = Nokogiri::HTML(open("https://www.erowid.org/experiences/exp.php?ID=#{@number}"))
    @trip = {}
    if valid_trip_report?
      scrape_text
      format_doses
    end
    write_trip_report
  end

  def valid_trip_report?
    return false if @doc.text['Unable to view experience']
    return false if @doc.css('div').css('.report-text-surround').empty?
    true 
  end

  def format_doses
    @trip[:doses] = []
    @doc.css('table.dosechart').css('tr').each do |dose|
      @trip[:doses] << format_dose_text(dose.text)
    end
  end

  def format_dose_text(text)
    text = text.gsub('DOSE:', '').delete("\n").delete("\t")
    # from Rails 'squish!' helper
    text.delete(/\A[[:space:]]+/).delete(/[[:space:]]+\z/).gsub(/[[:space:]]+/, ' ')
  end

  def scrape_text
    @trip[:text] = @doc.css('div').css('.report-text-surround').text
  end

  def write_trip_report
    File.open("trips/#{@number}.json", 'w') do |f|
      f.write(JSON.pretty_generate(@trip))
    end
  end
end

TRIP_RANGE = (1..200_000).to_a.map(&:to_s)

def scrape_all_trips
  TRIP_RANGE.each do |trip_number|
    puts "On number #{trip_number}"
    if File.exist?("trips/#{trip_number}.json")
      puts "File #{trip_number} already exists. Skipping..."
    else
      puts "Doing #{trip_number}"
      TripReportScraper.new(trip_number)
    end
  end
end
