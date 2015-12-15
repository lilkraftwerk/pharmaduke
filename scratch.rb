require_relative 'comic_scraper'
require_relative 'report_line'

# 10.times do 
#   t = TripReport.new
#   puts t.random_line
#   puts "*" * 20
# end

t = ComicScraper.new

test = []

1_000_000.times do |x|
  p x if x % 1000 == 0
  test << t.format_page_url
end

p test.uniq.length