require 'sinatra'
require 'sinatra/reloader' if development?

use Rack::Session::Cookie#, :expire_after => 0

get '/' do
  if session[:secret_word] == nil
    redirect to('/newgame')
  end
  variables
  erb :app
end

get '/newgame' do
  session[:secret_word] = generate_secret_word
  session[:result_display] = Array.new(session[:secret_word].length) {"_"}
  session[:guesses_left] = 7
  session[:guess_history] = []
  redirect to('/')
end

helpers do
  def variables
    @secret_word = session[:secret_word]
    @result_display = session[:result_display]
    @guesses_left = session[:guesses_left]
    @guess_history = session[:guess_history]
  end
  
  def generate_secret_word
    word_bank.sample
  end

  def word_bank
    words = File.open("./source.txt", 'r')
    word_bank = []
    
    words.each_line do |word|
      word_bank << word if word.strip.length > 5
    end
    words.close
    word_bank
  end  
end
