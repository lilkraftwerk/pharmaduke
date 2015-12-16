require 'nokogiri'
require 'json'
require 'open-uri'

class TripReportScraper
  def initialize(trip_number)
    @number = trip_number 
    @doc = Nokogiri::HTML(open("https://www.erowid.org/experiences/exp.php?ID=#{@number}"))
    @trip = {}
    if valid_trip_report?
      get_text
      get_doses
    end
    write_trip_report
  end

  def valid_trip_report?
    return false if @doc.text["Unable to view experience"]
    return false if @doc.css('div').css('.report-text-surround').empty?
    true 
  end

  def get_doses
    @trip[:doses] = []
    @doc.css('table.dosechart').css('tr').each do |dose| 
      @trip[:doses] << format_dose_text(dose.text)
    end
  end

  def format_dose_text(text)
    text = text.gsub("DOSE:", "").gsub("\n", "").gsub("\t", "").strip.lstrip
    test =  text.gsub(/\A[[:space:]]+/, '').gsub(/[[:space:]]+\z/, '').gsub(/[[:space:]]+/, ' ')
  end

  def get_text
    @trip[:text] = @doc.css('div').css('.report-text-surround').text
  end

  def write_trip_report
    puts "writing trip"
    File.open("trips/#{@number}.json","w") do |f|
      f.write(JSON.pretty_generate(@trip))
    end
  end
end

def get_all_trips
  TRIP_RANGE.each do |trip_number|
    puts "On number #{trip_number}"
    if File.exist?("trips/#{trip_number}.json")
      puts "File #{trip_number} already exists. Skipping..."
    else
      puts "Doing #{trip_number}"
      trip = TripReportScraper.new(trip_number) 
    end
  end
end

def get_all_good_trips
  good_trips = []
  File.open('goodones.txt').each do |line|
    good_trips << line.to_i
  end

  good_trips.map{|line| line.to_s}.each do |trip_number|
    puts "On number #{trip_number}"
    if File.exist?("trips/#{trip_number}.json")
      puts "File #{trip_number} already exists. Skipping..."
    else
      puts "Doing #{trip_number}"
      trip = TripReportScraper.new(trip_number) 
    end
  end
end

def get_all_old_trips_again
  dir = Dir["trips/old/*.json"]
  regex = /old\/(.+).json/
  trips = []
  dir.each do |filename|
    trips << regex.match(filename)[1]
  end

  trips.each do |trip_number|
    puts "On number #{trip_number}"
    if File.exist?("trips/#{trip_number}.json")
      puts "File #{trip_number} already exists. Skipping..."
    else
      puts "Doing #{trip_number}"
      trip = TripReportScraper.new(trip_number) 
    end
  end
end
