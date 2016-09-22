require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'


use Rack::Session::Cookie#, :expire_after => 0

get '/main.css' do
  scss :main
end

get '/' do
  if session[:secret_word] == nil
    redirect to('/start')
  end
  
  variables
  erb :app
end

get '/start' do
  session[:game_state] = ""
  session[:wait_screen] = ""
  session[:secret_word] = ""
  session[:invite] = "PRESS START"
  erb :start
end

get '/newgame' do
  session[:secret_word] = generate_secret_word.downcase.strip.split(//)
  session[:result_display] = Array.new(session[:secret_word].length) {"_"}
  session[:guesses_left] = 7
  session[:correct_guess_history] = []
  session[:incorrect_guess_history] = []
  session[:response] = ""
  redirect to('/')
end

post '/' do
  session[:guess] = params[:guess].downcase
  
  variables
  validate_input
  index_letters
  replace_letter
  update_history
  deduct_guesses
  
  if @secret_word == @result_display
    redirect to('/you_win')
  end
  
  if @guesses_left == 0
    redirect to('/you_lose')
  end
  
  erb :app
end

get '/you_win' do
  session[:game_state] = "MISSION SUCCESS"
  session[:wait_screen] = "wait-screen__figure--mission-success"
  session[:invite] = "KEEP PLAYING?"
  erb :win
end

get '/you_lose' do
  session[:game_state] = "GAME OVER"
  session[:wait_screen] = "wait-screen__figure--gameover"
  session[:invite] = "TRY AGAIN?"
  erb :lose
end

helpers do
  def variables
    @secret_word = session[:secret_word]
    @result_display = session[:result_display]
    @correct_guess_history = session[:correct_guess_history]
    @incorrect_guess_history = session[:incorrect_guess_history]
    @guess = session[:guess]
  end
  
  def validate_input
    one_character_only
    letters_only
    no_repeats
    session[:response] = ""
  end
  
  def one_character_only
    if @guess.length != 1
      session[:response] = "One character only"
      redirect to('/') 
    end
  end
  
  def letters_only
    if !("a".."z").include? @guess
      session[:response] = "Letters only"
      redirect to('/') 
    end
  end
  
  def no_repeats
    no_correct_repeats
    no_incorrect_repeats
  end
  
  def no_correct_repeats
    if @correct_guess_history.include? @guess
      session[:response] = "No correct repeats"
      redirect to('/') 
    end
  end
  
  def no_incorrect_repeats
    if @incorrect_guess_history.include? @guess
      session[:response] = "No incorrect repeats"
      redirect to('/') 
    end
  end
  
  def deduct_guesses
    session[:guesses_left] -= 1 if !(@secret_word.include? @guess)
    @guesses_left = session[:guesses_left]
  end
  
  def update_history
    update_correct_guess_history
    update_incorrect_guess_history
  end
  
  def update_correct_guess_history
    @correct_guess_history << @guess if @secret_word.include? @guess
  end
  
  def update_incorrect_guess_history
    @incorrect_guess_history << @guess if !(@secret_word.include? @guess)
  end
    
  def index_letters
    @secret_word.each_index.select { |i| @secret_word[i] == @guess }
  end
  
  def replace_letter
    index_letters.each { |i| @result_display[i] = @guess }
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
