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
    @final = background_image.composite(@image, 0, 0, Magick::OverCompositeOp)
    @new_filename = "output/#{rand(1000)}_crop.png"
    @final.write(@new_filename)
  end

  def make_background
    set_html
    p @html
    puts "making file"
    kit = IMGKit.new(@html, quality: 100, width: 300, height: 375)
    kit.stylesheets << "css/styles.css"
    file = kit.to_file("tmp/file#{rand(1..100)}.jpg")
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

  # def create_image(file_number)
  # puts "creating image #{file_number}"

  # garkov = Garkov.new
  # sentence = garkov.sentence

  # gifs = get_list_of_strips

  # gifs.shuffle!

  # image1 = Magick::ImageList.new(gifs.shift)
  # image2 = Magick::ImageList.new(gifs.shift)
  # image3 = Magick::ImageList.new(gifs.shift)
  # cropped1 = image3.crop(0, 0, 200, 178)
  # cropped2 = image2.crop(200, 0, 200, 178)
  # cropped3 = image1.crop(400, 0, 200, 178)

  # new_image = Image.new(600, 178)

  # cropped1 = fuck_up_image(cropped1)
  # cropped2 = fuck_up_image(cropped2)
  # cropped3 = fuck_up_image(cropped3)

  # new_image.composite!(cropped1, 0, 0, Magick::OverCompositeOp)
  # new_image.composite!(cropped2, 200, 0, Magick::OverCompositeOp)
  # new_image.composite!(cropped3, 400, 0, Magick::OverCompositeOp)


  # rand(5).times do
  #   text.annotate(new_image, rand(500), rand(178), rand(600), rand(178), garkov.sentence.upcase) {
  #     self.fill = random_color
  #     self.pointsize = rand(30)
  #     self.rotation = (rand(20) - 10)
  #     self.font_weight = BoldWeight
  #   }
  # end

  # 3.times do
  #   new_image = fuck_up_image(new_image) if roll_dice
  # end

  # puts "wrote tmp/glitch#{format_number(file_number)}.png"
end

n = ImageMaker.new