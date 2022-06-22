puts "Please, type your name: "
name = gets.chomp
puts "Your height (cm): "
height = Integer(gets.chomp)
puts "Your weight (kg): "
weight = Integer(gets.chomp)

ideal_formula = 1.15 * (height - 110)

if weight <= ideal_formula
	puts "#{name}, your waight is already optimal!"
else
	puts "Hi #{name}, your idel weight is #{ideal_formula.to_s}!"
end