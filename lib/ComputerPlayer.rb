require_relative 'SecretWordArrays.rb'
require_relative 'TheHangedMan.rb'
class Computer_Player
  include Secret_word_arrays, The_Hanged_Man

  attr_accessor :body_parts_hanged, :random_number, :the_word, :number_of_blanks_to_fill, :winner, :reset

  def initialize(body_parts_hanged, random_number, the_word,number_of_blanks_to_fill)
    @body_parts_hanged = body_parts_hanged
    @random_number = random_number
    @the_word = the_word
    @number_of_blanks_to_fill = number_of_blanks_to_fill
    @winner = false
    @reset = false
  end

  def to_json #methed to save game to json file
    File.write('computer_save.json',JSON.dump({
      :body_parts_hanged => @body_parts_hanged,
      :random_number => @random_number,
      :the_word=> @the_word,
      :number_of_blanks_to_fill => @number_of_blanks_to_fill
    }))
  end

  def self.from_json(computer_save) #method to pull saved computer player data from json to ruby file and setting the values to a new instance of ComputerPlayer
    save_file = File.read(computer_save)
    data = JSON.parse(save_file)
    self.new(data['body_parts_hanged'],data['random_number'],data['the_word'], data['number_of_blanks_to_fill'])
  end

  def pick_the_word()
    @random_number = rand(@@secret_word_array.length) #a random number is picked based on the length of the array created from the list of words
    @the_word = @@secret_word_array[@random_number] #the random number is used to pick the word to guess the letters for 
    return @theWord
  end

  def set_the_blanks()
    @number_of_blanks_to_fill = "_ " * @the_word.length #the visual of the blanks that nead to be filled to solve the game
  end

  def check_the_letter(letter) #method to check the guessed letter by the player
    letter_position = 0
    wrong_letter_count = 0
    if letter.length == 1 #needed so that a hang man part isn't added when entering 'exit' and marking it as a wrong letter 
      @the_word.each_char do |a| #for each letter in the word to guess
        #puts letterPosition
        if letter == a #if the guessed letter matches the current letter of the word
            @number_of_blanks_to_fill[letter_position] = letter #the dash gets replaced by the letter
        else 
          wrong_letter_count+=1 #used as a counter for whether to add a body part to hangman
        end
        letter_position+=2 #shifts the position that the next dash should be in (they are separated by a space to make it easier to see how many dashes there are)
      end
      if wrong_letter_count == @the_word.length #if the letter doesn't match any letters of the word a body part is added to the hangman
        @body_parts_hanged +=1
      end
      puts " ",@number_of_blanks_to_fill, " "
    end
  end

  def draw_hang_man 
    case @body_parts_hanged 
    when 0 #when bodyPartsHanged = 0 blank gallow
      puts @@hanged_man_array
    when 1 #when bodyPartsHanged = 1 
      @@hanged_man_array.delete_at(1) #delete the placeholder 
      @@hanged_man_array.insert(1,@@blank_head) #add blank head
      puts @@hanged_man_array
    when 2
      @@hanged_man_array.delete_at(1) 
      @@hanged_man_array.insert(1,@@mouth) #same as before but adds head and mouth
      puts @@hanged_man_array
    when 3
      @@hanged_man_array.delete_at(1)
      @@hanged_man_array.insert(1,@@left_eye)# adds mouth, left eye, and head
      puts @@hanged_man_array
    when 4
      @@hanged_man_array.delete_at(1)
      @@hanged_man_array.insert(1,@@full_head) #adds head, both eyes, & mouth
      puts @@hanged_man_array
    when 5
      @@hanged_man_array.delete_at(1)
      @@hanged_man_array.insert(1,@@full_head)
      @@hanged_man_array.delete_at(2) #same as above and then deletes second placeholder
      @@hanged_man_array.insert(2,@@torso) #adds torso in place
      puts @@hanged_man_array
    when 6
      @@hanged_man_array.delete_at(1)
      @@hanged_man_array.insert(1,@@full_head) 
      @@hanged_man_array.delete_at(2)
      @@hanged_man_array.insert(2,@@left_arm) #adds left arm and torso
      puts @@hanged_man_array
    when 7
      @@hanged_man_array.delete_at(1) 
      @@hanged_man_array.insert(1,@@full_head)
      @@hanged_man_array.delete_at(2)
      @@hanged_man_array.insert(2,@@arms_and_body_row) #adds both arms and torso
      puts @@hanged_man_array
    when 8
      @@hanged_man_array.delete_at(1)
      @@hanged_man_array.insert(1,@@full_head)
      @@hanged_man_array.delete_at(2)
      @@hanged_man_array.insert(2,@@arms_and_body_row)
      @@hanged_man_array.delete_at(3)
      @@hanged_man_array.insert(3,@@left_leg) #adds left leg along with the rest of the body
      puts @@hanged_man_array
    when 9
      @@hanged_man_array.delete_at(1)
      @@hanged_man_array.insert(1,@@full_head)
      @@hanged_man_array.delete_at(2)
      @@hanged_man_array.insert(2,@@arms_and_body_row)
      @@hanged_man_array.delete_at(3)
      @@hanged_man_array.insert(3,@@legs_row) #adds right and left leg to the rest of the body

      puts @@hanged_man_array
      puts "Game over!"
      puts "\nthe word was #{@the_word}" 
      @winner = true

    else puts "You aren\'t supposed to be here!" #for fun
    end
  end

  def new_game(letter_guessed, guess_array, player_winner) #method to reset the game
    The_Hanged_Man.set_hanged_man #resets hangman to blank gallow
    @body_parts_hanged = 0
    @random_number = 0
    @the_word = ""
    @number_of_blanks_to_fill = ""
    @winner = false
    letter_guessed = ""
    guess_array.clear
    player_winner = false
  end

end
