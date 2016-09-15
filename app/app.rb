class Game
  attr_reader :secret_word, :guess
  attr_accessor :result
  
  def initialize
    @secret_word = "committee".split(//)
    # @secret_word = word_bank.strip.split(//)
    @result = Array.new(secret_word.length) { "_" }
    @@guesses_left = 2
    
    check_state
  end
  
  
  
  def check_state
    while result != secret_word do
      play
      lose_state?
      win_state?
    end
  end
  
  private
  
  def play
    get_input
    replace_letter
    deduct_guesses
    p result
  end
  
  
  def lose_state?
    if @@guesses_left == 0
      puts "You lost: Guesses reached zero."
      exit
    end
  end
  
  def win_state?
    if result == secret_word
      puts "You won: The secret word was '#{secret_word.join}'!"
    end
  end
  
  def deduct_guesses
    @@guesses_left -= 1 if !(secret_word.include? guess)
    puts "Your guesses remaining: #{@@guesses_left}."
  end
    
  def get_input
    puts "Guess input:"
    @guess = gets.chomp
  end
  
  
  def word_bank
    words = File.read("/source.txt")
    word_bank = []
    
    words.each_line do |word|
      word_bank << word if word.strip.length > 5
    end
    
    words.close
    word_bank.sample
  end
  
  def letter_index
    letter_index = secret_word.each_index.select { |i| secret_word[i] == guess }
  end
  
  def replace_letter
    letter_index.each { |i| result[i] = guess }
  end
  
end


Game.new