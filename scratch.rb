require_relative 'comic_scraper'
require_relative 'report_line'


test = []

10.times do |x|
  t = TripReport.new
  puts t.random_line
  puts "*" * 10 
  puts
end

p test.uniq.length


# t = ComicScraper.new


# 1_000_000.times do |x|
#   test << t.format_page_url
# end

# p test.uniq.length