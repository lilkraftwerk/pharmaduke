class TripReport
  attr_reader :line, :dose

  def initialize
    @trips = Dir['trips/*.json']
    read_file
    split_sentences
    format_line
    format_dose
  end

  def read_file
    @filename = @trips.sample
    @file = JSON.parse(File.open(@filename).read)
    read_file if @file.empty?
  end

  def split_sentences
    @split = Scalpel.cut(@file['text'])
  end

  def format_line
    line = @split.sample
    if line_is_good?(line)
      @line = ['"', line, '"'].join('')
    else
      format_line
    end
  end

  def format_dose
    doses = @file['doses']
    doses = doses[0..-2] until doses.join("\n").length < 116
    @dose = doses.join("\n")
    @dose = 'UNKNOWN' if @dose == ''
  end

  def line_is_good?(line)
    return false unless line['DOSE'].nil?
    return false unless line['BODY WEIGHT'].nil?
    return false unless line.length > 50
    return false unless line.length < 150
    return false unless ('A'..'Z').include?(line[0])
    true
  end
end
