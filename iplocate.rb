#!/usr/bin/env ruby
# used for integrating into command line
# https://commandercoriander.net/blog/2013/02/16/making-a-ruby-script-executable/

require 'json'
require 'open-uri'

@command_argument = ARGV.first
@command_type = nil
@user_input = nil
@ip = nil
@hostname = nil
@loc = nil
@org = nil
@city = nil
@region = nil
@country = nil
@phone = nil
@undefined = "undefined"

def show_name()
  puts """

  .-..---.        .--.             .-.                     .-.  _
  : :: .; :      : .--'            : :                    .' `.:_;
  : ::  _.'_____ : : _  .--.  .--. : :   .--.  .--.  .--. `. .'.-. .--. ,-.,-.
  : :: :  :_____:: :; :' '_.'' .; :: :_ ' .; :'  ..'' .; ; : : : :' .; :: ,. :
  :_;:_;         `.__.'`.__.'`.__.'`.__;`.__.'`.__.'`.__,_;:_; :_;`.__.':_;:_;

  𝓢𝓪𝓫𝓾𝓻𝓸

  For options type: options
  or
  CTRL-C to exit
  """
end

def check_format()
  if @command_argument.include?(".txt")
    @command_type = "txt"
  else
    @command_type = "IP"
  end
end

def get_info()
  if @command_type == "IP"
    # replace with parse json
    @ip = open("http://ipinfo.io/#{@command_argument}/ip").read.chomp # use to double check against command_argument
    @hostname = open("http://ipinfo.io/#{@command_argument}/hostname").read.chomp
    @loc = open("http://ipinfo.io/#{@command_argument}/loc").read.chomp
    @org = open("http://ipinfo.io/#{@command_argument}/org").read.chomp
    @city = open("http://ipinfo.io/#{@command_argument}/city").read.chomp
    @region = open("http://ipinfo.io/#{@command_argument}/region").read.chomp
    @country = open("http://ipinfo.io/#{@command_argument}/country").read.chomp
    @phone = open("http://ipinfo.io/#{@command_argument}/phone").read.chomp
  elsif @command_type == "txt" # not checked
    puts "I made it"
    txt_file = open(@command_argument, 'r+')
    # take off .txt from the name
    @command_argument_as_array = @command_argument.split("")
    *prefix, four,three, two, one = @command_argument_as_array
    @short_file_name = prefix.join("")

    new_txt_file = open("#{@short_file_name}(with city).txt", 'w') # make a new txt file using the oldname plus (withcity)

    @line_number = 1
    txt_file.each do |line|
      @line_ip_city = open("http://ipinfo.io/#{line.chomp}/city").read.chomp
      new_txt_file.write("#{line.chomp} City: #{@line_ip_city}\n")
      puts "Working on line #{@line_number}: #{"#{line.chomp} City: #{@line_ip_city}\n"}"
      @line_number = @line_number + 1
    end
    @line_number = 1
    new_txt_file.close()
    txt_file.close()
  end
end

def show_instance_values()
  puts "Collected Info"
  puts ">>"
  puts "command argument: #{@command_argument}"
  puts "command type: #{@command_type}"
  puts "user input: #{@user_input}"
  puts "ip: #{@ip}"
  puts "hostname: #{@hostname}"
  puts "location: #{@loc}"
  puts "organization: #{@org}"
  puts "city: #{@city}"
  puts "region: #{@region}"
  puts "country: #{@country}"
  puts "phone: #{@phone}"
  # puts "undefined: #{@undefined}"
  puts "<<"
end

def run()
  while @user_input == nil do
      @user_input = $stdin.gets.chomp
      # use switch case instead of if statements
      if @user_input == "" || @user_input == "nil"
        puts "Please enter a valid command or press CTRL-C to exit."
        @user_input = nil
      elsif @user_input == "options"
        puts "commands go here"
        @user_input = nil
      elsif @user_input == "display"
        show_instance_values()
        @user_input = nil
      else
        puts "ごめん I don't understand \"#{@user_input}\"\nPlease enter a valid command or press CTRL-C to exit."
      end
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

# program starts here
show_name()
print "Locating..."
show_wait_spinner{
  check_format()
  get_info()
}
puts "Done!"
puts "IP:\"#{@ip}\" City:\"#{@city}\""
# http://stackoverflow.com/questions/10262235/printing-an-ascii-spinning-cursor-in-the-console

run()
