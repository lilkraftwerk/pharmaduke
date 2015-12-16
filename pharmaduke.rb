require_relative 'config'

def tweet
  image = ImageMaker.new
  filename = image.new_filename
  tweeter = CustomTwitter.new
  tweeter.update(image.report.dose, File.open(filename))
end

def local_image
  ImageMaker.new(local: true)
end

def should_tweet?
  last_tweet_older_than_four_hours?
end

def timed_tweet
  tweet if should_tweet?
end

def last_tweet_older_than_four_hours?
  client = CustomTwitter.new
  client.last_tweet_older_than_four_hours?
end
