require 'json'
require 'open-uri'

@ip = ARGV.first
@city = nil
@input = nil

def get_city()
  if @ip != nil
    @city = open("http://ipinfo.io/#{@ip}/city").read.chomp
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

print "Locating..."
show_wait_spinner{
  get_city()
}
puts "Done!"
puts "IP:\"#{@ip}\" City:\"#{@city}\""
# http://stackoverflow.com/questions/10262235/printing-an-ascii-spinning-cursor-in-the-console

def display_name()
  puts """

  .-..---.        .--.             .-.                     .-.  _
  : :: .; :      : .--'            : :                    .' `.:_;
  : ::  _.'_____ : : _  .--.  .--. : :   .--.  .--.  .--. `. .'.-. .--. ,-.,-.
  : :: :  :_____:: :; :' '_.'' .; :: :_ ' .; :'  ..'' .; ; : : : :' .; :: ,. :
  :_;:_;         `.__.'`.__.'`.__.'`.__;`.__.'`.__.'`.__,_;:_; :_;`.__.':_;:_;

  For options type: options
  or
  CTRL-C to exit

  """
  while @input == nil do
      @input = $stdin.gets.chomp
      if @input == "" || "options"
        puts "ごめん I don't understand \"#{@input}\"\nPlease enter a valid command or press CTRL-C to exit."
        @input = nil
      end
  end
end

display_name()

=begin
check if argument 1 is ip or .txt file
if ip get json and update all class variables
if txt open txt in append mode ask user for userinput
=end
