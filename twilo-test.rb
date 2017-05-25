require 'rubygems'
require 'twilio-ruby'
#require 'sinatra'

# get '/' do
#     'Hello World! Currently running version ' + Twilio::VERSION + \
#         ' of the twilio-ruby library.'
# end

account_sid = "AC514458d03f8edbc936c750104207c5fa"
auth_token = "5abcdc520129d99eda6f4f127c722fc3"
client = Twilio::REST::Client.new account_sid, auth_token
from = "+18583815995" # Your Twilio number

# friends = {
# "+233505929330" => "Opeyemi",
# "+233238130430" => "Musty"
# }
#friends = Company.users.telephone
# friends.each do |key, value|
  client.account.messages.create(
    :from => from,
    :to =>  "+233238130430",
    :body => "Hi Musty, We noticed you have not completed your interview. Pls go do so here"
  )
  #puts "Sent message to #{value}"
#end