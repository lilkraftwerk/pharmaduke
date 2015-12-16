class ComicScraper
  def format_page_url
    date = format_date
    "http://www.gocomics.com/marmaduke/#{date[:year]}/#{date[:month]}/#{date[:day]}"
  end

  def format_date
    date = {}
    date[:year] = make_year
    date[:month] = make_month
    date[:day] = make_day
    format_date if sunday?(date)
    date
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
    page_url = format_page_url
    Nokogiri::HTML(open(page_url)).css('.strip').attr('src').value
  end

  def write_strip
    url = search_for_strip_url
    image = Magick::ImageList.new
    urlimage = open(url)
    image.from_blob(urlimage.read)
  rescue OpenURI::HTTPError
    retry
  else
    filename = "tmp/strip_#{rand(100)}.gif"
    image.write(filename)
    return filename
  end
end
