require 'json'
require 'scalpel'
require 'pry'

class TripReport
  attr_reader :line, :dose

  def initialize
    @trips = Dir["trips/*.json"]
    get_file
    split_sentences
  end

  def get_file
    @filename = @trips.shuffle.first
    @file = JSON.parse(File.open(@filename).read)
    if @file.empty?
      get_file
    end
  end

  def split_sentences
    @split = Scalpel.cut(@file['text'])
  end

  def random_line
    line = @split.shuffle.first
    unless line_is_good?(line)
      random_line
    else
      return ['"', line, '"'].join("")
    end
  end

  def line_is_good?(line)
    return false unless line["DOSE"].nil?
    return false unless line["BODY WEIGHT"].nil?
    return false unless line.length > 50
    return false unless line.length < 150
    return false unless ('A'..'Z').include?(line[0])
    return true
  end
end