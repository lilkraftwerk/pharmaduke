# http://www.gocomics.com/marmaduke/2015/12/05

require 'rmagick'
require 'open-uri'
require 'pry'
require 'nokogiri'
require 'date'

def format_page_url
  date = get_date
  "http://www.gocomics.com/marmaduke/#{date[:year]}/#{date[:month]}/#{date[:day]}"
end

def get_date
  date = {}
  date[:year] = make_year
  date[:month] = make_month
  date[:day] = make_day
  if is_sunday?(date)
    get_date
  else 
    return date
  end
end

def is_sunday?(date)
  date_to_test = Date.new(date[:year].to_i, date[:month].to_i, date[:day].to_i)
  date_to_test.strftime("%A") == "Sunday"
end

def make_day
  day = (1..28).to_a.sample
  if day < 10
    day = "0#{day}"
  end
  day.to_s
end

def make_month
  month = (1..12).to_a.sample
  if month < 10
    month = "0#{month}"
  end
  month.to_s
end

def make_year
  year = (1997..2014).to_a.sample
end

def get_strip_url
  true
end

def get_strip_page
  page_url = format_page_url
end

def get_strip_url
  page_url = get_strip_page
  Nokogiri::HTML(open(page_url)).css('.strip').attr('src').value
end

def write_strip(url)
  begin
    url = get_strip_url
    image = Magick::ImageList.new
    urlimage = open(url)
    image.from_blob(urlimage.read)
  rescue OpenURI::HTTPError
    puts "porblem. retrying..."
    retry
  else
    puts "we made it, writing image"
    image.write("tmp/strip_#{rand(10)}.gif")
  end
end

get_strip_url

