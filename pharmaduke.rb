require_relative 'image_maker'
require_relative 'custom_twitter'

def tweet
  image = ImageMaker.new
  filename = image.new_filename
  tweeter = CustomTwitter.new
  tweeter.update('test', File.open(filename))
end

def local_image
  image = ImageMaker.new
  filename = image.new_filename
end

def should_tweet?
  last_tweet_older_than_four_hours?
end

def timed_tweet
  tweet if should_tweet?
end

def last_tweet_older_than_four_hours?
  client = CustomTwitter.new
  client.is_last_tweet_older_than_four_hours
end

