class HumanPlayer 

  attr_accessor :score, :winner, :letterGuessed, :guessArray, :reset, :pullThePlug
  def initialize(score, letterGuessed, guessArray)
    @score = score

    @letterGuessed= letterGuessed
    @guessArray = guessArray
    @reset = false
    @winner = false
    @pullThePlug = false
  end

  def to_json #method for saving player data to json file if quitting
    File.write('gameSave.json',JSON.dump({
      :score => @score,
      :letterGuessed => @letterGuessed,
      :guessArray=> @guessArray
    }))
  end

  def self.from_json(playerSave) #for loading json data from previous save to instance of HumanPlayer class
    saveFile = File.read(playerSave)
    data = JSON.parse(saveFile) 
    self.new(data['score'],data['letterGuessed'],data['guessArray'])
  end


  def playerTurn() #method for entering a guess letter
    puts "What letter would you like to guess?"
    puts "Type exit to quit."
    @letterGuessed = gets.chomp 
    unless @letterGuessed.length < 2 || @letterGuessed == "exit" #only allows 1 letter guesses or the word 'exit' to be entered
      puts "Only enter one letter or the word exit. Thank you!"
      @letterGuessed = gets.chomp
    end
    #for exiting the game
    if @letterGuessed == "exit"
      @pullThePlug = true

    else
      @letterGuessed.downcase!
      @guessArray << @letterGuessed #guess array used to show player what letters they have used so far to avoid duplicates
    end
  end

  def checkForWin(word, computerWinner) 
    unless word.include?("_") #checks if the numberOfBlanksToFill variable has any dashes left. If they have all been filled the player got all the letters and won.
      @score += 1
      puts "You Win! Your score is #{@score} \n"
      @winner = true

      else 
        if @guessArray.length > 0 && computerWinner == false #if the hangman isn't full the array of guessed letters is printed unless there are no letters in the array (for the start of a new game)
          puts "\n#{@guessArray} \n"
        end
    end
  end

  def playAgain(computerWinner) #method to go through if you want a rematch
    puts "Do you want to play again?"
    playAgain = gets.chomp
    playAgain.downcase!

    until playAgain == "yes" or playAgain == "no" #only allows yes or no responses
      puts "Enter yes or no only!"
      playAgain = gets.chomp
      playAgain.downcase!
    end

    if playAgain == "no" #if response is no it breaks the game loop
      puts "\nBYEEEEE!"
      @winner = true
      computerWinner = true

    else
      puts "\nLet's start over" #if response is yes (the only other acceptable response) it begins the reset loop in the game loop
      @winner = false
      computerWinner = false
      @reset = true
    end
  end

end
