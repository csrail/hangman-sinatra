require 'sinatra'
require 'sinatra/reloader' if development?

enable :sessions

configure do
  generate_secret_word
end

get '/' do
  
  erb :app, :locals => { :testing => "",
                         :secret_word => secret_word,
                         :feedback1 => @feedback1,
                         :feedback2 => @feedback2
                       }
end

post '/' do
  session['guess'] = params['guess']
  validate_input
  
  erb :app, :locals => { :testing => session['guess'],
                         :feedback1 => @feedback1,
                         :feedback2 => @feedback2
                        }
end



def validate_input
  letters_only
  one_character_only
end

def letters_only
  if !("a".."z").include? session['guess']
    @feedback1 = "That's not a letter."
    @feedback2 = "Only searching for letters:"
  end
end

def one_character_only
  if session['guess'].length != 1
    @feedback1 = "That's not quite one character."
    @feedback2 = "Only searching for one character:"
  end
end

def secret_word
  @@secret_word
end

def generate_secret_word
  @@secret_word = word_bank.strip.split(//)
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