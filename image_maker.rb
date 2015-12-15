require_relative 'report_line'
require_relative 'comic_scraper'

class ImageMaker
  def initialize
    @report = TripReport.new
    @filename = ComicScraper.new.write_strip
    @image = Magick::Image.read(@filename)[0]
    @image = @image.crop(0, 0, 300, 300)
    @background = Magick::Image.read("images/background.png")[0]
    @final = @background.composite(@image, 0, 0, Magick::OverCompositeOp)
    write_text

    @final.write("tmp/#{rand(1000)}_crop.png")
  # new_image.write("tmp/glitch#{format_number(file_number)}.png")
  end

  def write_text
    sentence = word_wrap(@report.random_line)
    text = Magick::Draw.new
    text.font = "images/Arial.ttf"
    text.annotate(@final, 300, 50, 5, 315, sentence) {
      self.fill = 'Black'
      self.pointsize = 15
    }
  end

  def word_wrap(sentence)
    columns = 47
    sentence.split("\n").collect do |line|
      line.length > columns ? line.gsub(/(.{1,#{columns}})(\s+|$)/, "\\1\n").strip : line
    end * "\n"
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