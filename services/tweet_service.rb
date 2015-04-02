require 'sinatra/activerecord'

require_relative '../models/tweet'
require_relative 'user_service'

class TweetService

def self.tweets_by_user_id(user_id)
  tweets = Tweet.where(user_id: user_id).limit(100).order created_at: :desc
  full_tweets = []
  users = tweets.collect { |id, text| id }
  puts "users: #{users}"
  user_ids = UserService.get_by_ids users
  puts "user ids: #{user_ids}"
  for i in 0...tweets.count
    verify_tweet user_ids[i], tweets[i], full_tweets
  end
  # tweets.each do |tweet|
  #   verify_tweet user, tweet, full_tweets
  # end

  full_tweets
end

  def self.tweets
    tweets = Tweet.limit(100).order created_at: :desc
    full_tweets = []
    users = tweets.collect {|id, text| id }
    puts "users: #{users}"
    user_ids = UserService.get_by_ids users
    puts "user ids: #{user_ids}"
    for i in 0...tweets.count
      verify_tweet user_ids[i], tweets[i], full_tweets
    end
    # tweets.each do |tweet|
    #   user = UserService.get_by_id tweet[:user_id]
    #   verify_tweet user, tweet, full_tweets
    # end

    full_tweets
  end

  def self.new(params)
    begin
      tweet = Tweet.create(
          text: params[:text],
          user_id: params[:user_id]
      )

      if tweet.valid?
        tweet.to_json
      else
        error 400, tweet.errors.to_json
      end
    end
  end


  private

# Verifies a tweet's user is valid.
  def self.verify_tweet(user, tweet, array)
    if user
      array.push [tweet, user]
    else
      # Kill a tweet if it belongs to a user that no longer exists
      Tweet.destroy tweet[:id]
    end
  end

end