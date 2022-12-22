import tweepy
import datetime

# Insert your Twitter API keys here
consumer_key = ""
consumer_secret = ""
access_token = ""
access_token_secret = ""

# Authenticate with Twitter API
auth = tweepy.OAuth1UserHandler(consumer_key, consumer_secret, access_token, access_token_secret)
api = tweepy.API(auth)

# Set the date for 30 days ago
thirty_days_ago = datetime.datetime.utcnow() - datetime.timedelta(days=30)

# Get all of the user's tweets
tweets = api.user_timeline()

# Iterate through the tweets and delete those that are older than 30 days
for tweet in tweets:
  if tweet.created_at < thirty_days_ago:
    api.destroy_status(tweet.id)
    print(f"Deleted tweet from {tweet.created_at}: {tweet.text}")
  else:
    break

print("Finished deleting old tweets.")

# end
#
#