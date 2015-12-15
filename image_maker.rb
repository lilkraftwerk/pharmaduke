require_relative 'report_line'
require_relative 'comic_scraper'

require 'imgkit'
require 'json'
require 'pathname'
require 'pry'

class ImageMaker
  attr_reader :new_filename

  def initialize
    @report = TripReport.new
    get_strip
    crop_image
    background_filename = make_background
    background_image = Magick::Image.read(background_filename)[0]
    @final = background_image.composite(@image, 7.5, 5, Magick::OverCompositeOp)
    @new_filename = "output/#{Time.now}.png"
    @final.write(@new_filename)
  end

  def get_strip
    @filename = ComicScraper.new.write_strip
    @image = Magick::Image.read(@filename)[0]
    get_strip if @image.columns > 310
    puts "*" * 10
    puts "height: #{@image.rows}, width: #{@image.columns}"
  end

  def crop_image
    width = 300
    if @image.rows <= 316
      puts "LOWER" * 3
      height = 292
    else
      puts "HIGHER" * 3
      height = 300
    end
    @image = @image.crop(0, 0, width, height)
  end

  def make_background
    set_html
    p @html
    puts "making file"
    kit = IMGKit.new(@html, quality: 100, width: 305, height: 400)
    kit.stylesheets << "css/styles.css"
    file = kit.to_file("tmp/#{Time.now}.jpg")
    file
  end

  def set_html
    @html = [
      "<!DOCTYPE html>",
      "<html>",
      "<head>",
      "<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>",
      "</head",
      "<body>",
      "<div class='container'>",
      "<div class='blankspace'></div>",
      "<div class='report'>#{@report.random_line}</div></div>",
      "</body>",
      "</html>"
    ].join("")
  end
end