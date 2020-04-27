k = "hello 'world' good 'world' gm"

string_pos = k.gsub(/\'/).map { Regexp.last_match.begin(0)}
line = k
start = 0
i = 0
while i < string_pos.length do
  line = line.gsub(k[string_pos[i]..string_pos[i+1]], "")
  i += 2
end



puts string_pos,k
puts line