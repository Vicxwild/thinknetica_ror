fibonacci = []
x = 0
fibonacci.push(x)
y = 1
fibonacci.push(y)
z = 0

loop do
  z = x + y
  break if z > 100
  fibonacci.push(z)
  x = y
  y = z
  
end

puts fibonacci