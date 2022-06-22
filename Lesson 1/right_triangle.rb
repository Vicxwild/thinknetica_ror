puts "The length of the first side is: "
a_side = Integer(gets.chomp)
puts "The length of the second side is: "
b_side = Integer(gets.chomp)
puts "The length of the third side is: "
c_side = Integer(gets.chomp)

if a_side > b_side && a_side > c_side
	puts "Triangle is a right" if a_side ** 2 == b_side ** 2 + c_side ** 2
elsif b_side > a_side && b_side > c_side
	puts "Triangle is a right" if b_side ** 2 == a_side ** 2 + c_side ** 2
elsif c_side > a_side && c_side > b_side
	puts "Triangle is a right" if c_side ** 2 == a_side ** 2 + b_side ** 2
else
	puts "krivo!!!!!!!"
end