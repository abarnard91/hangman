require "json"
require_relative 'lib/HumanPlayer.rb'
require_relative'lib/ComputerPlayer.rb'
require_relative 'lib/TheHangedMan.rb'
require_relative 'lib/SecretWordArrays.rb'

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
