require 'nokogiri'
require 'json'
require 'open-uri'
require 'pry'

class TripReportScraper
  def initialize(trip_number)
    @number = trip_number 
    @doc = Nokogiri::HTML(open("https://www.erowid.org/experiences/exp.php?ID=#{@number}"))
    @trip = {}
    get_text if valid_trip_report?
    write_trip_report
  end

  def valid_trip_report?
    return false if @doc.text["Unable to view experience"]
    return false if @doc.css('div').css('.report-text-surround').empty?
    true 
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


TRIP_RANGE = (1..106861).to_a.map{|number| number.to_s}

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

get_all_trips