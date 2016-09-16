require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  
  erb :app
end

def word_bank
  words = File.open("./source.txt", 'r')
  word_bank = []
  
  words.each_line do |word|
    word_bank << word if word.strip.length > 5
  end
  words.close
  word_bank.sample
end