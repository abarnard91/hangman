module The_Hanged_Man #all the parts to draw a hangman character 
  @@top_row =              " |----|"
  @@full_head =            " |  (\ˣ-\ˣ) "
  @@arms_and_body_row =      " |   /|\\"
  @@legs_row =             " |   / \\"
  @@base_row =             "/ \\" 
  @@blank_row =            " | "
  @@torso =               " |    | "
  @@left_arm =             " |   /|"
  @@left_leg =             " |   /"
  @@blank_head =           " |  (   ) "
  @@mouth =               " |  ( _ ) "
  @@left_eye =             " |  (\ˣ- ) "

  def self.set_hanged_man #class method to create a blank hangman
    @@hanged_man_array = [@@top_row, @@blank_row, @@blank_row,@@blank_row,@@base_row]
  end
  set_hanged_man()

end
