alphabet = {}

array = ('a'..'z').to_a

array.each do |letter| 
	alphabet[letter] = array.index(letter) + 1 if ['a', 'e', 'i', 'o', 'u'].include?(letter)
end