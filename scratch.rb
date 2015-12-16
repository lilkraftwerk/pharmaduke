require_relative 'comic_scraper'
require_relative 'report_line'
require_relative 'pharmaduke'

test = []

10.times do |x|
  t = TripReport.new
  puts t.random_line
  puts "*" * 10 
  puts
end

# 20.times do |x|
  # local_image
# end

p test.uniq.length


# t = ComicScraper.new


# 1_000_000.times do |x|
#   test << t.format_page_url
# end

# p test.uniq.length