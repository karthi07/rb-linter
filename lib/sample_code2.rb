def add_pos( pos )
  # chk the pos range here 
  pos1 = pos - 1
  ind1 = pos1 / 3 + pos1 / 3 +1
  ind2 = pos1 % 3 + pos1 % 3 + 1
  # gameboard[ind1][ind2] = sym
  puts ("#{ind1} , #{ ind2}")
end
k = [ 1,2,3 ]
k = 1...10
k.each { |i| add_pos(i)}
