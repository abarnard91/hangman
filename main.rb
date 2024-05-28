require "json"

module TheHangedMan #all the parts to draw a hangman character 
  @@topRow =              " |----|"
  @@fullHead =            " |  (\ˣ-\ˣ) "
  @@armsAndBodyRow =      " |   /|\\"
  @@legsRow =             " |   / \\"
  @@baseRow =             "/ \\" 
  @@blankRow =            " | "
  @@torso =               " |    | "
  @@leftArm =             " |   /|"
  @@leftLeg =             " |   /"
  @@blankHead =           " |  (   ) "
  @@mouth =               " |  ( _ ) "
  @@leftEye =             " |  (\ˣ- ) "

  def self.setHangedMan #class method to create a blank hangman
    @@hangedManArray = [@@topRow, @@blankRow, @@blankRow,@@blankRow,@@baseRow]
  end
  setHangedMan()

end
  

module SecretWordArrays
  
  @@secretWordArray = Array.new #array that pulls words from 10000 words google text doc
  @@tenthousandWords = File.readlines("google-10000-english-no-swears.txt")
  @@tenthousandWords.each do |word|
    word.strip! #words in text file have an extra space so its removed 
    if word.length >= 5 and word.length < 13 # then only words that are between 5-12 letters in length added to the secret word Array
      @@secretWordArray << word
    end
  end
end

  
class ComputerPlayer
  include SecretWordArrays, TheHangedMan
  
  attr_accessor :bodyPartsHanged, :randomNumber, :theWord, :numberOfBlanksToFill, :winner, :reset
  
  def initialize(bodyPartsHanged, randomNumber, theWord,numberOfBlanksToFill)
    @bodyPartsHanged = bodyPartsHanged
    @randomNumber = randomNumber
    @theWord = theWord
    @numberOfBlanksToFill = numberOfBlanksToFill
    @winner = false
    @reset = false
  end

  def to_json #methed to save game to json file
    File.write('computerSave.json',JSON.dump({
      :bodyPartsHanged => @bodyPartsHanged,
      :randomNumber => @randomNumber,
      :theWord=> @theWord,
      :numberOfBlanksToFill => @numberOfBlanksToFill
    }))
  end

  def self.from_json(computerSave) #method to pull saved computer player data from json to ruby file and setting the values to a new instance of ComputerPlayer
    saveFile = File.read(computerSave)
    data = JSON.parse(saveFile)
    self.new(data['bodyPartsHanged'],data['randomNumber'],data['theWord'], data['numberOfBlanksToFill'])
  end

  def pickTheWord()
    @randomNumber = rand(@@secretWordArray.length) #a random number is picked based on the length of the array created from the list of words
    @theWord = @@secretWordArray[@randomNumber] #the random number is used to pick the word to guess the letters for 
    return @theWord
  end

  def setTheBlanks()
    @numberOfBlanksToFill = "_ " * @theWord.length #the visual of the blanks that nead to be filled to solve the game
  end

  def checkTheLetter(letter) #method to check the guessed letter by the player
    letterPosition = 0
    wrongLetterCount = 0
    if letter.length == 1 #needed so that a hang man part isn't added when entering 'exit' and marking it as a wrong letter 
      @theWord.each_char do |a| #for each letter in the word to guess
        #puts letterPosition
        if letter == a #if the guessed letter matches the current letter of the word
            @numberOfBlanksToFill[letterPosition] = letter #the dash gets replaced by the letter
        else 
          wrongLetterCount+=1 #used as a counter for whether to add a body part to hangman
        end
        letterPosition+=2 #shifts the position that the next dash should be in (they are separated by a space to make it easier to see how many dashes there are)
      end
      if wrongLetterCount == @theWord.length #if the letter doesn't match any letters of the word a body part is added to the hangman
        @bodyPartsHanged +=1
      end
      puts " ",@numberOfBlanksToFill, " "
    end
  end
          
  def drawHangMan 
    case @bodyPartsHanged 
    when 0 #when bodyPartsHanged = 0 blank gallow
      puts @@hangedManArray
    when 1 #when bodyPartsHanged = 1 
      @@hangedManArray.delete_at(1) #delete the placeholder 
      @@hangedManArray.insert(1,@@blankHead) #add blank head
      puts @@hangedManArray
    when 2
      @@hangedManArray.delete_at(1) 
      @@hangedManArray.insert(1,@@mouth) #same as before but adds head and mouth
      puts @@hangedManArray
    when 3
      @@hangedManArray.delete_at(1)
      @@hangedManArray.insert(1,@@leftEye)# adds mouth, left eye, and head
      puts @@hangedManArray
    when 4
      @@hangedManArray.delete_at(1)
      @@hangedManArray.insert(1,@@fullHead) #adds head, both eyes, & mouth
      puts @@hangedManArray
    when 5
      @@hangedManArray.delete_at(1)
      @@hangedManArray.insert(1,@@fullHead)
      @@hangedManArray.delete_at(2) #same as above and then deletes second placeholder
      @@hangedManArray.insert(2,@@torso) #adds torso in place
      puts @@hangedManArray
    when 6
      @@hangedManArray.delete_at(1)
      @@hangedManArray.insert(1,@@fullHead) 
      @@hangedManArray.delete_at(2)
      @@hangedManArray.insert(2,@@leftArm) #adds left arm and torso
      puts @@hangedManArray
    when 7
      @@hangedManArray.delete_at(1) 
      @@hangedManArray.insert(1,@@fullHead)
      @@hangedManArray.delete_at(2)
      @@hangedManArray.insert(2,@@armsAndBodyRow) #adds both arms and torso
      puts @@hangedManArray
    when 8
      @@hangedManArray.delete_at(1)
      @@hangedManArray.insert(1,@@fullHead)
      @@hangedManArray.delete_at(2)
      @@hangedManArray.insert(2,@@armsAndBodyRow)
      @@hangedManArray.delete_at(3)
      @@hangedManArray.insert(3,@@leftLeg) #adds left leg along with the rest of the body
      puts @@hangedManArray
    when 9
      @@hangedManArray.delete_at(1)
      @@hangedManArray.insert(1,@@fullHead)
      @@hangedManArray.delete_at(2)
      @@hangedManArray.insert(2,@@armsAndBodyRow)
      @@hangedManArray.delete_at(3)
      @@hangedManArray.insert(3,@@legsRow) #adds right and left leg to the rest of the body
      
      puts @@hangedManArray
      puts "Game over!"
      puts "\nthe word was #{@theWord}" 
      @winner = true
      
    else puts "You aren\'t supposed to be here!" #for fun
    end
  end
  
  def newGame(letterGuessed, guessArray, playerWinner) #method to reset the game
    TheHangedMan.setHangedMan #resets hangman to blank gallow
    @bodyPartsHanged = 0
    @randomNumber = 0
    @theWord = ""
    @numberOfBlanksToFill = ""
    @winner = false
    letterGuessed = ""
    guessArray.clear
    playerWinner = false
  end
  
end

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

#start game by choosing a saved game or new game
puts "Would you like to start a new game or load a saved game? Enter new or save"
startGameResponse = gets.chomp.downcase
unless startGameResponse == "new" or startGameResponse == "save"
  puts "Please, only enter new or save. Thank you"
end

if startGameResponse == 'new'
  #for new game
  newWord = ComputerPlayer.new(0,0,'','')
  playerOne = HumanPlayer.new(0,'',[])
  newWord.pickTheWord()
  newWord.setTheBlanks()
  #puts newWord.theWord #for debugging

else
  #for saved game
  playerOne = HumanPlayer.from_json('gameSave.json')
  newWord = ComputerPlayer.from_json('computerSave.json')
  newWord.drawHangMan()
  puts "#{playerOne.guessArray}"
end

puts  newWord.numberOfBlanksToFill,''

#game loop
while playerOne.winner == false && newWord.winner == false && playerOne.pullThePlug == false
  playerOne.playerTurn()
  newWord.checkTheLetter(playerOne.letterGuessed)
  newWord.drawHangMan()
  playerOne.checkForWin(newWord.numberOfBlanksToFill,newWord.winner)
  
  if playerOne.winner == true || newWord.winner == true
    playerOne.playAgain(newWord.winner)
  end

  if playerOne.pullThePlug == true
    puts "Would you like to save your game?"
    exit_response = gets.chomp.downcase
    unless exit_response == "yes" || exit_response == "no"
      puts "Just say yes or no"
      exit_response = gets.chomp.downcase
    end
    if exit_response == 'no'
      puts "Bye!"
    else
      puts "Saving..."
      playerOne.to_json()
      newWord.to_json()
      puts "Game saved. See you next time!"
    end
  end
  
  if playerOne.reset == true
    newWord.newGame(playerOne.letterGuessed, playerOne.guessArray, playerOne.winner)
    newWord.pickTheWord()
    newWord.setTheBlanks()
    #puts newWord.theWord # for debugging
    puts  newWord.numberOfBlanksToFill,''
    playerOne.reset = false
  end
end
