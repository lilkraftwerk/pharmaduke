require 'twitter'
require 'active_support'
require 'active_support/time'

unless ENV["HEROKTRUE"]
  require_relative 'keys.rb'
end

TWITTER_KEY ||= ENV["TWITTER_KEY"]
TWITTER_SECRET ||= ENV["TWITTER_SECRET"]
ACCESS_TOKEN ||= ENV["ACCESS_TOKEN"]
ACCESS_SECRET ||= ENV["ACCESS_SECRET"]

class CustomTwitter
  attr_reader :client

  def initialize
    configure_twitter_client
  end

  def configure_twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = TWITTER_KEY
      config.consumer_secret = TWITTER_SECRET
      config.access_token = ACCESS_TOKEN
      config.access_token_secret = ACCESS_SECRET
    end
  end

  def is_last_tweet_older_than_four_hours
    last = @client.user_timeline.first.created_at
    puts "should we tweet? #{last <= 2.hours.ago}"
    last <= 2.hours.ago
  end

  def update(text, image)
    @client.update_with_media(text, image)
  end

  def search(text)
    @client.search(text, result_type: "recent")
  end
end

