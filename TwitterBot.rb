# -*- coding: utf-8 -*-
$KCODE = "UTF8"
require 'rubygems'
require 'open-uri'
require 'oauth'
require 'rss'
require 'cgi'

#--------- TwitterBot ---------
class TwitterBot

  # ...の部分を適切な文字列に置き換える
  def initialize
    @consumer = OAuth::Consumer.new(
      @CONSUMER_KEY = ".......................................",
      @CONSUMER_SECRET = ".....................................",
      :site => 'https://twitter.com'
    )
    @access_token = OAuth::AccessToken.new(
      @consumer,
      @ACCESS_TOKEN = "..........................................",
      @ACCESS_TOKEN_SECRET = "............................................."
    )
  end

#--------- ツイート---------
  def tweet( message )
    @access_token.post(
      '/statuses/update.rss',
      'status' => message
    )
  end

#--------- ツイート受信 <+0000の時刻,発言内容,発言者> ---------
  def get_tweet
    response = @access_token.get(
      '/statuses/friends_timeline.rss'
    )

    sours = CGI.unescapeHTML(response.body).to_s
    tweet = Array.new
    time = Array.new
    descriptions = Array.new

    time = sours.scan( /\<pubDate\>.*\<\/pubDate\>/ ).collect{|x| x.gsub( /\<.?pubDate\>/, "")}
    descriptions = sours.scan( /\<description\>.*\<\/description\>/ ).collect{|x| x.gsub( /\<.?description\>/, "")}
    descriptions.shift

    descriptions.each do |description|
      description =~ /([^:]*):(.*)/
      tweet << {"name" => $1, "message" => $2, "time" => time.shift}
    end

    return tweet
  end

end