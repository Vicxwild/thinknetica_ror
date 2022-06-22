puts "Enter the length of the triangle base: "
base = Integer(gets.chomp)
puts "Its height: "
height = Integer(gets.chomp)

area = 0.5 * base * height
puts "Triangle area is #{area.to_s}"