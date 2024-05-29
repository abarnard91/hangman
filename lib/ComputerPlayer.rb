require_relative 'SecretWordArrays.rb'
require_relative 'TheHangedMan.rb'
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
