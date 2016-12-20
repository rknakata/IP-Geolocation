require 'json'
require 'open-uri'

ip = ARGV.first
@city = nil

def get_city(ip)
  if ip != nil
    @city = (open("http://ipinfo.io/#{ip}/city").read)
    #puts "#{city}"
    return @city
  else
    puts "no ip given"
    return nil
  end
end

def show_wait_spinner(fps=10)
  chars = %w[| / - \\]
  delay = 1.0/fps
  iter = 0
  spinner = Thread.new do
    while iter do  # Keep spinning until told otherwise
      print chars[(iter+=1) % chars.length]
      sleep delay
      print "\b"
    end
  end
  yield.tap{       # After yielding to the block, save the return value
    iter = false   # Tell the thread to exit, cleaning up after itself…
    spinner.join   # …and wait for it to do so.
  }                # Use the block's return value as the method's
end

print "Doing something tricky..."
show_wait_spinner{
  #sleep rand(4)+2 # Simulate a task taking an unknown amount of time
  get_city(ip)
}
puts "Done!"
puts @city
# http://stackoverflow.com/questions/10262235/printing-an-ascii-spinning-cursor-in-the-console

intro = """"""

puts intro
