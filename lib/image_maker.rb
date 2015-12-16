class ImageMaker
  attr_reader :new_filename, :report

  def initialize(options = {})
    @report = TripReport.new
    get_strip
    find_bottom_of_comic
    crop_image
    background_filename = make_background
    background_image = Magick::Image.read(background_filename)[0]
    @final = background_image.composite(@image, 7.5, 5, Magick::OverCompositeOp)
    @new_filename = "tmp/#{rand(10000)}.png" unless options[:local]
    @new_filename = "output/#{Time.now}.png" if options[:local]
    @final.write(@new_filename)
  end

  def get_strip
    @filename = ComicScraper.new.write_strip
    @image = Magick::Image.read(@filename)[0]
    get_strip if @image.columns > 310
  end

  def find_bottom_of_comic
    results = {}
    adjusted_height = @image.rows - 12
    (285..adjusted_height).to_a.each do |y_value|
      results[y_value] = test_line_in_comic(y_value)
    end
    @comic_bottom = results.sort_by{ |_k, v| v }.first.first
  end

  def test_line_in_comic(y_value)
    total = 0
    300.times do |x_value|
      color = @image.pixel_color(x_value, y_value)
      total += color.red / 257
      total += color.green / 257
      total += color.blue / 257
    end
    total 
  end

  def crop_image
    width = 300
    height = @comic_bottom + 2
    @image = @image.crop(0, 0, width, height)
  end

  def make_background
    set_html
    height = 395 - (300 - @comic_bottom)
    kit = IMGKit.new(@html, quality: 100, width: 305, height: height)
    kit.stylesheets << 'css/styles.css'
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
      "<div style='height: #{@comic_bottom};' class='blankspace'></div>",
      "<div class='report'>#{@report.line}</div></div>",
      "</body>",
      "</html>"
    ].join('')
  end
end
