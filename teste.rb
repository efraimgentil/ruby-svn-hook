
puts ARGV[0]

get = ARGV[0]
m = get.scan /([\w]+=[\w\\\/:]+)/
puts m 
#puts "\\".ord.chr
