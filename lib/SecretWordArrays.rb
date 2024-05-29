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
