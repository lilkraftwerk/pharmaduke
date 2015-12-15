require_relative 'comic_scraper'
require_relative 'report_line'

# 10.times do 
#   t = TripReport.new
#   puts t.random_line
#   puts "*" * 20
# end

t = ComicScraper.new

100.times do 
  p t.format_page_url
end