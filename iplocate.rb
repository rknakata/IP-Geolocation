require 'json'
require 'open-uri'

ip = ARGV.first
if ip != nil
  city = (open("http://ipinfo.io/#{ip}/city").read)
  puts city
end
