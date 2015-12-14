require 'json'

class TripReport
  def initialize
    @trips = Dir["trips/*.json"]
    get_file
    split_sentences
  end

  def get_file
    @file = JSON.parse(File.open(@trips.shuffle.first).read)
    get_file until !@file.empty?
  end

  def split_sentences
    @split = @file['text'].scan(/[^\.!?]+[\.!?]/).map(&:strip)
  end

  def random_line
    line = @split.shuffle.first
  end
end


10.times do |x|
  length = 200 
  trip = TripReport.new
  line = trip.random_line
  length = line.length
  until length < 120 && length > 30
    line = trip.random_line
    length = line.length
  end
  puts line
  puts
end