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
    unless line_is_good?(line)
      random_line
    else
      return line
    end
  end

  def line_is_good?(line)
    return false unless line["DOSE"].nil?
    return false unless line["BODY WEIGHT"].nil?
    return false unless line.length > 30
    return false unless line.length < 120
    return true
  end
end