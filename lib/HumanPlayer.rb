class Human_Player 

  attr_accessor :score, :winner, :letter_guessed, :guess_array, :reset, :pull_the_plug
  def initialize(score, letter_guessed, guess_array)
    @score = score

    @letter_guessed= letter_guessed
    @guess_array = guess_array
    @reset = false
    @winner = false
    @pull_the_plug = false
  end

  def to_json #method for saving player data to json file if quitting
    File.write('game_save.json',JSON.dump({
      :score => @score,
      :letter_guessed => @letter_guessed,
      :guess_array=> @guess_array
    }))
  end

  def self.from_json(player_save) #for loading json data from previous save to instance of HumanPlayer class
    save_file = File.read(player_save)
    data = JSON.parse(save_file) 
    self.new(data['score'],data['letter_guessed'],data['guess_array'])
  end


  def player_turn() #method for entering a guess letter
    puts "What letter would you like to guess?"
    puts "Type exit to quit."
    @letter_guessed = gets.chomp 
    unless @letter_guessed.length < 2 || @letter_guessed == "exit" #only allows 1 letter guesses or the word 'exit' to be entered
      puts "Only enter one letter or the word exit. Thank you!"
      @letter_guessed = gets.chomp
    end
    #for exiting the game
    if @letter_guessed == "exit"
      @pull_the_plug = true

    else
      @letter_guessed.downcase!
      @guess_array << @letter_guessed #guess array used to show player what letters they have used so far to avoid duplicates
    end
  end

  def check_for_win(word, computer_winner) 
    unless word.include?("_") #checks if the numberOfBlanksToFill variable has any dashes left. If they have all been filled the player got all the letters and won.
      @score += 1
      puts "You Win! Your score is #{@score} \n"
      @winner = true

      else 
        if @guess_array.length > 0 && computer_winner == false #if the hangman isn't full the array of guessed letters is printed unless there are no letters in the array (for the start of a new game)
          puts "\n#{@guess_array} \n"
        end
    end
  end

  def play_again(computer_winner) #method to go through if you want a rematch
    puts "Do you want to play again?"
    play_again = gets.chomp
    play_again.downcase!

    until play_again == "yes" or play_again == "no" #only allows yes or no responses
      puts "Enter yes or no only!"
      play_again = gets.chomp
      play_again.downcase!
    end

    if play_again == "no" #if response is no it breaks the game loop
      puts "\nBYEEEEE!"
      @winner = true
      computer_winner = true

    else
      puts "\nLet's start over" #if response is yes (the only other acceptable response) it begins the reset loop in the game loop
      @winner = false
      computer_winner = false
      @reset = true
    end
  end

end
