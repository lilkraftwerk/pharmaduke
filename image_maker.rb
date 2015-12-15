require_relative 'report_line'
require_relative 'comic_scraper'

require 'imgkit'
require 'json'
require 'pathname'

class ImageMaker
  def initialize
    @report = TripReport.new
    @filename = ComicScraper.new.write_strip
    @image = Magick::Image.read(@filename)[0]
    @image = @image.crop(0, 0, 300, 300)
    background_filename = make_background
    background_image = Magick::Image.read(background_filename)[0]
    @final = background_image.composite(@image, 7.5, 5, Magick::OverCompositeOp)
    @new_filename = "output/#{Time.now}.png"
    @final.write(@new_filename)
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

20.times {n = ImageMaker.new}