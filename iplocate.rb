require 'json'
require 'open-uri'

ip = ARGV.first

city = (open("http://ipinfo.io/#{ip}/city").read)

puts city
