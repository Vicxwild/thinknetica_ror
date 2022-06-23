puts "a = "
a = Integer(gets.chomp)
puts "b = "
b = Integer(gets.chomp)
puts "c = "
c = Integer(gets.chomp)

d = b ** 2 - 4 * a * c

if d > 0
	x_one = (-b + d ** 0.5) / (2 * a)
	x_two = (-b - d ** 0.5) / (2 * a)

	puts "d = #{d}, x1 = #{x_one}, x2 = #{x_two}"
elsif d == 0
	x = -b / (2 * a)
	puts "d = #{d}, x = #{x}"
else 
	puts "d = #{d}, корней нет!"
end
