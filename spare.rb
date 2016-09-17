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