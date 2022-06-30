common_year = {
	january: 31,
	february: 28,
	march: 31,
	april: 30,
	may: 31,
	june: 30,
	july: 31,
	august: 31,
	september: 30,
	october: 31,
	november: 30,
	december: 31
}

puts "Enter the date: "
day = gets.chomp
puts "Enter the month: "
month = gets.chomp.to_sym
puts "Enter the year: "
year = gets.chomp.to_i
months = []

if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
	common_year[:february] = 29
end

common_year.each do |name, days|
	break if name == month
	months << days
end

puts months.sum + day.to_i


