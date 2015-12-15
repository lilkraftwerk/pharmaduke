if ENV["HEROKTRUE"]
  puts "doin manual wkhtmltoimage"
  IMGKit.configure do |config|
     config.wkhtmltoimage = File.join('bin', 'wkhtmltoimage-amd64').to_s
  end
else
  puts "not using manual wkhtmltoimage"
end
