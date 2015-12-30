#connect Rstudio to Twitter

library(twitteR)
library(RJSONIO)
library(ROAuth)
library(RCurl) 
library(bitops)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))

download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")


api_key <- "yZ6xhaxgTrMT3vbGyJE3xwbAe"
api_secret <- "oBu6ixv8xYgSoEnR6yYyixFFfYdEdSDBvjfEP5bEE2AaMzVYvg"
access_token <- "2897266928-8c1p0MJvGFuKDPYoJTuEDHXhUlKZI21ypg8EjAI"
access_token_secret <- "VcMzN9hF21oZVyosr6BwinB0MlPlsNtMcBhZx1gjJZmpI"



reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"


consumerKey <- "yZ6xhaxgTrMT3vbGyJE3xwbAe"
consumerSecret <- "oBu6ixv8xYgSoEnR6yYyixFFfYdEdSDBvjfEP5bEE2AaMzVYvg"

twitCred <- OAuthFactory$new(consumerKey=consumerKey,
                             consumerSecret=consumerSecret,
                             requestURL=reqURL,
                             accessURL=accessURL,
                             authURL=authURL)

twitCred$handshake()

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


####test code

TweetFrame <- function(searchTerm, maxTweets){
  twtList <- searchTwitter(searchTerm, n = maxTweets)
  df <- do.call("rbind", lapply(twtList, as.data.frame))
  sortDF <- df[order(as.integer(df$created)),]
  return (sortDF)
}

tweetDF <- TweetFrame("#ladygaga", 500)
testSearch <- searchTwitter("#food", n = 10)
