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
