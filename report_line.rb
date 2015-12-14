require 'json'

class TripReport
  def initialize
    @trips = Dir["trips/*.json"]
    get_file
    split_sentences
  end

  def get_file
    filename = @trips.shuffle.first
    puts filename
    @file = JSON.parse(File.open(filename).read)
    if @file.empty?
      get_file
    end
  end

  def split_sentences
    @split = @file['text'].scan(/[^\.!?]+[\.!?]/).map(&:strip)
  end

  def random_line
    line = @split.shuffle.first
    unless line["DOSE"].nil? && line["BODY WEIGHT"].nil?
      random_line
    else
      return line
    end
  end
end


10.times do |x|
  length = 200 
  trip = TripReport.new
  line = trip.random_line
  length = line.length
  until length < 140 && length > 20
    line = trip.random_line
    length = line.length
  end
  puts line
  puts
end