# http://www.gocomics.com/marmaduke/2015/12/05
# http://images.ucomics.com/comics/ga/1990/ga900216.gif

require 'rmagick'
require 'open-uri'

# def format_url
#   year = make_year
#   year_short = year.to_s[-2..-1]
#   month = make_month
#   day = make_day
#   "http://images.ucomics.com/comics/ga/#{year}/ga#{year_short}#{month}#{day}.gif"
# end

# def is_sunday?

# end

# def make_day
#   day = (1..28).to_a.sample
#   if day < 10
#     day = "0#{day}"
#   end
#   day.to_s
# end

# def make_month
#   month = (1..12).to_a.sample
#   if month < 10
#     month = "0#{month}"
#   end
#   month.to_s
# end

# def make_year
#   year = (1997..2014).to_a.sample
# end

def write_strip
  begin
    image = Magick::ImageList.new
    urlimage = open('http://assets.amuniversal.com/d9540ea07a3301332158005056a9545d')
    image.from_blob(urlimage.read)
  rescue OpenURI::HTTPError
    puts "porblem. retrying..."
    retry
  else
    puts "we made it, writing image"
    image.write("tmp/strip_#{1}.gif")
  end
end

write_strip