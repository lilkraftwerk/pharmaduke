class ComicScraper
  def format_page_url
    @date = format_date
    "http://www.gocomics.com/marmaduke/#{@date[:year]}/#{@date[:month]}/#{@date[:day]}"
  end

  def format_date
    date = {}
    date[:year] = make_year
    date[:month] = make_month
    date[:day] = make_day
    puts "sunday: #{sunday?(date)}"
    format_date if sunday?(date)
    date
  end

  def redirected_to_latest_comic?
    @doc.css('a').css('.newest').empty?
  end

  def sunday?(date)
    date_to_test = Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
    date_to_test.strftime('%A') == 'Sunday'
  end

  def make_day
    day = (1..28).to_a.sample
    day = "0#{day}" if day < 10
    day
  end

  def make_month
    month = (1..12).to_a.sample
    "0#{month}" if month < 10
    month
  end

  def make_year
    (1997..2014).to_a.sample
  end

  def search_for_strip_url
    @doc = Nokogiri::HTML(open(format_page_url))
    search_for_strip_url if redirected_to_latest_comic? 
    @strip_url = @doc.css('.strip').attr('src').value
  end

  def write_strip
    search_for_strip_url
    image = Magick::ImageList.new
    urlimage = open(@strip_url)
    image.from_blob(urlimage.read)
  rescue OpenURI::HTTPError
    retry
  else
    filename = "tmp/strip_#{@date[:year]}#{@date[:month]}#{@date[:day]}.gif"
    image.write(filename)
    return filename
  end
end
