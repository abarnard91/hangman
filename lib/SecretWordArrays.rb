module Secret_word_arrays

  @@secret_word_array = Array.new #array that pulls words from 10000 words google text doc
  @@ten_thousand_words = File.readlines("google-10000-english-no-swears.txt")
  @@ten_thousand_words.each do |word|
    word.strip! #words in text file have an extra space so its removed 
    if word.length >= 5 and word.length < 13 # then only words that are between 5-12 letters in length added to the secret word Array
      @@secret_word_array << word
    end
  end
end
