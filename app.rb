require 'sinatra'
require 'sinatra/reloader' if development?

use Rack::Session::Cookie#, :expire_after => 0

helpers do
  def generate_secret_word
    word_bank.strip.split(//)
  end
  
  def result
    @result = Array.new(session['secret_word'].length) { "_" }
  end
  
  def letter_index
    session['secret_word'].each_index.select { |i| session['secret_word'][i] == session['guess'] }
  end
  
  def replace_letter
    letter_index.each { |i| result[i] = session['guess'] }
  end
end

get '/' do
  session['secret_word'] ||= generate_secret_word
  
  
  
  erb :app, :locals => { :player_guess => "",
                         :secret_word => session['secret_word'],
                         :result => @result
                       }
end

post '/' do
  session['guess'] = params['guess']
  replace_letter
  
  erb :app, :locals => { :player_guess => session['guess'],
                         :secret_word => session['secret_word'],
                         :result => @result
                        }
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