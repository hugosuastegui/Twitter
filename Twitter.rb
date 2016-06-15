## Miercoles 15 de Junio del 2016
## CSV
## HSP y MRM

# $ ruby twitter_scrapper.rb
# Username: Chicharito Hernandez
# ----------------------------------------------------------------------------
# Stats: Tweets: 734, Siguiendo: 298, Seguidores: 4,95M, Favoritos: 70
# ----------------------------------------------------------------------------
# Tweets: 
#   30 de mar.: Somos futbolistas unidos por una gran causa. Entendamos juntos al autismo @iluminemosazul https://www.youtube.com/watch?v=g3umuOWdMyA … #Iluminemosdeazul 
#   Retweets:862, Favorites:1,6K

#   30 de mar.: Felicidades churuuuuuu @SergioRamos que la pases muy bien!!!  #top pic.twitter.com/ulhTMRk38V 
#   Retweets:2,6K, Favorites:5,3K

#   29 de mar.: Fe y confianza!!!... Muchísimas gracias por el gran apoyo en LA!... #blessed pic.twitter.com/oOiEmYhKQt 
#   Retweets:3,3K, Favorites:7K

require 'nokogiri'
require 'open-uri'


class TwitterScrapper
  attr_accessor :username, :number_tweets, :followers, :following, :likes, :tweets

  def initialize(url)
    @username
    @number_tweets
    @followers
    @following
    @likes
    @tweets = []
    doc = Nokogiri::HTML(open(url))
    extract_username(doc)
    extract_tweets(doc) 
    extract_stats(doc)
  end

  def extract_username(doc)
    @username = doc.search(".ProfileHeaderCard-name > a").inner_text
  end

  def extract_tweets(doc)
    for i in 0..5
     @tweets << {date: doc.search("._timestamp")[i].inner_text, tweet: doc.search(".tweet-text")[i].inner_text, retweets: doc.search(".js-actionRetweet").search(".ProfileTweet-actionCountForPresentation")[i*2].inner_text, favorites: doc.search(".js-actionFavorite").search(".ProfileTweet-actionCountForPresentation")[i*2].inner_text}
    end
  end

  def extract_stats(doc)
    @number_tweets = doc.search("span.ProfileNav-value")[0].inner_text
    @following = doc.search("span.ProfileNav-value")[1].inner_text
    @followers = doc.search("span.ProfileNav-value")[2].inner_text
    @likes = doc.search("span.ProfileNav-value")[3].inner_text
  end

end

#
class Layout
  def initialize(object)
    puts "Username:  #{object.username}"
    puts "----------------------------------------------------------------------------"
    puts "Stats: Tweets: #{object.number_tweets}, Siguiendo: #{object.following}, Seguidores: #{object.followers}, Favoritos: #{object.likes} "
    puts "----------------------------------------------------------------------------"
    puts "Tweets: "
    object.tweets.each do |tweet|
      puts "#{tweet[:date]} : #{tweet[:tweet]}"
      puts "Retweets:#{tweet[:retweets]} , Favourites:#{tweet[:favorites]} "
    end
  end
end

new_url = ARGV[0]
url = new_url
twitter_ch14 = TwitterScrapper.new(url)
ch14 = Layout.new(twitter_ch14)


