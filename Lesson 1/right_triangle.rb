puts "The length of the first side is: "
a_side = Integer(gets.chomp)
puts "The length of the second side is: "
b_side = Integer(gets.chomp)
puts "The length of the third side is: "
c_side = Integer(gets.chomp)

if a_side > b_side && a_side > c_side
	hupotenuse = a_side
	cathet_1 = b_side
	cathet_2 = c_side
elsif b_side > a_side && b_side > c_side
	hupotenuse = b_side
	cathet_1 = a_side
	cathet_2 = c_side
elsif c_side > a_side && c_side > b_side
	hupotenuse = c_side
	cathet_1 = a_side
	cathet_2 = b_side
end

if a_side == b_side && b_side == c_side
	puts "The triangle is equilateral"
elsif a_side == b_side || b_side == c_side || c_side == a_side
	puts "The triangle is isosceles"
elsif hupotenuse ** 2 == (cathet_1 ** 2 + cathet_2 ** 2)
	puts "The triangle is rectangulare"
else 
	puts "An ordinary triangle"
end