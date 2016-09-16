class Game
  attr_reader :secret_word, :guess, :result,
              :history_correct, :history_incorrect
  #attr_accessor 
  
  def initialize
    @secret_word = "committee".split(//)
    # @secret_word = word_bank.strip.split(//)
    @result = Array.new(secret_word.length) { "_" }
    @@guesses_left = 2
    
    @history_correct = []
    @history_incorrect = []
    
    check_state
  end
  
  
  private
  
  def check_state
    while result != secret_word do
      play
      lose_state?
      win_state?
    end
  end
  
  def validate_input
    one_character_only
    letters_only
    no_repeats
  end
  
  def one_character_only
    until guess.length == 1
      p "That's not quite one character."
      p "Only searching for one character:"
      get_input
    end
  end
  
  def letters_only
    until ("a".."z").include? guess
      p "That's not a letter."
      p "Only searching for letters:"
      get_input
    end
  end
  
  def no_repeats
    no_correct_repeats
    no_incorrect_repeats
  end
  
  def no_correct_repeats
    until !(history_correct.include? guess)
      p "You've correctly guessed '#{guess}' before."
      p "Only searching for new guesses:"
      get_input
    end
  end
  
  def no_incorrect_repeats
    until !(history_incorrect.include? guess)
      p "You've incorrectly guessed '#{guess}' before."
      p "Only searching for correct guesses:"
      get_input
    end
  end
  
  
  def play
    p "Get input:"
    get_input
    replace_letter
    deduct_guesses
    update_history
    p result
    p "Incorrect guess history: #{history_incorrect}"
    p "Correct guess history: #{history_correct}"
  end
  
  def get_input
    listen_for_input
    validate_input
  end
  
  def update_history
    history_incorrect << guess if !(secret_word.include? guess)
    history_correct << guess if secret_word.include? guess
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
    
  def listen_for_input
    @guess = gets.chomp.downcase
  end
  
  def letter_index
    letter_index = secret_word.each_index.select { |i| secret_word[i] == guess }
  end
  
  def replace_letter
    letter_index.each { |i| result[i] = guess }
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
  
end


Game.new