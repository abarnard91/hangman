require "json"
require_relative 'lib/HumanPlayer.rb'
require_relative'lib/ComputerPlayer.rb'
require_relative 'lib/TheHangedMan.rb'
require_relative 'lib/SecretWordArrays.rb'

#start game by choosing a saved game or new game
puts "Would you like to start a new game or load a saved game? Enter new or save"
start_game_response = gets.chomp.downcase
until start_game_response == "new" or start_game_response == "save"
  puts "Please, only enter new or save. Thank you"
  start_game_response = gets.chomp.downcase
end

if start_game_response == 'new'
  #for new game
  new_word = Computer_Player.new(0,0,'','')
  player_one = Human_Player.new(0,'',[])
  new_word.pick_the_word()
  new_word.set_the_blanks()
  #puts newWord.theWord #for debugging

else
  #for saved game
  player_one = Human_Player.from_json('game_save.json')
  new_word = Computer_Player.from_json('computer_save.json')
  new_word.draw_hang_man()
  puts "#{player_one.guess_array}"
end

puts  new_word.number_of_blanks_to_fill,''

#game loop
while player_one.winner == false && new_word.winner == false && player_one.pull_the_plug == false
  player_one.player_turn()
  new_word.check_the_letter(player_one.letter_guessed)
  new_word.draw_hang_man()
  player_one.check_for_win(new_word.number_of_blanks_to_fill,new_word.winner)
  
  if player_one.winner == true || new_word.winner == true
    player_one.play_again(new_word.winner)
  end

  if player_one.pull_the_plug== true
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
      player_one.to_json()
      new_word.to_json()
      puts "Game saved. See you next time!"
    end
  end
  
  if player_one.reset == true
    new_word.new_game(player_one.letter_guessed, player_one.guess_array, player_one.winner)
    new_word.pick_the_word()
    new_word.set_the_blanks()
    #puts newWord.theWord # for debugging
    puts  new_word.number_of_blanks_to_fill,''
    player_one.reset = false
  end
end
