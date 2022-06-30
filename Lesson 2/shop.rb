purchases = {}

loop do
	puts "Enter the name of product(to finish enter \"stop\"): "
	product = gets.chomp
	break if product == 'stop'
	puts "Enter the unit price of the product: "
	price = gets.chomp.to_f
	puts "Enter the amount of product: "
	amount = gets.chomp.to_f
	
	purchases[product] = { price: price, amount: amount }
end

basket = []

purchases.each do |key, val|
	total_price = val[:price] * val[:amount]
	basket << total_price
	puts "#{key}, #{val}, total price is: #{total_price}"
end

puts "Total prise of a grocery basket: #{basket.sum}"