require 'twitter'
require 'active_support'
require 'active_support/time'
require 'rmagick'
require 'open-uri'
require 'nokogiri'
require 'date'
require 'imgkit'
require 'json'
require 'pathname'
require 'json'
require 'scalpel'

require_relative 'comic_scraper'
require_relative 'custom_twitter'
require_relative 'image_maker'
require_relative 'report_line'

require_relative 'keys.rb' unless ENV['HEROKTRUE']

if ENV['HEROKTRUE']
  puts 'doin manual wkhtmltoimage'
  IMGKit.configure do |config|
     config.wkhtmltoimage = File.join('bin', 'wkhtmltoimage-amd64').to_s
  end
else
  puts 'not using manual wkhtmltoimage'
end
