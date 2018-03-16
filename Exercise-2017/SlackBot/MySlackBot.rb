# coding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sinatra'
require 'SlackBot'

class MySlackBot < SlackBot
  def test(params, options={})
    user_name = params[:user_name] ? "@#{params[:user_name]}" : ""
    msg = params[:text]
    msg = msg.match(/^「(.*)」と言って/)
    return {text: "#{user_name} #{msg[1]}"}.merge(options).to_json
  end
end

slackbot = MySlackBot.new

set :environment, :production

get '/' do
  "SlackBot Server"
end

post '/slack' do
  content_type :json
  slackbot.test(params, username: "Bot")
  #  slackbot.naive_respond(params, username: "Bot")
end
