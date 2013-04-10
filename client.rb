require 'socket'
require_relative 'client_commands'

class Stock
  attr_accessor :stocks
  @stocks = [ ]
  
  def initialize(c)
    @stocks = c.list_stocks.split(' ').collect { |symbol| 
      [ symbol, c.price(symbol).split(' ')[1].to_f, nil ] 
      }
    stocks.shift # drop the command "OK" from the list
  end
  
  def display_status(c,counter)
    puts "\e[H\e[2J" # clear screen
    @stocks.each do |symbol,old_price,new_price|
      new_price = c.price(symbol).split(' ')[1].to_f
      delta = new_price - old_price
      percent = 100* (delta / old_price )    
      status = "%6s " % symbol
      status << "price:$%3.2f " % new_price
      status << "change:$%3.2f " % delta
      status << "(%3.2f" % percent + '%)'
      puts status 
    end
      puts "counter: #{counter}"
  end
  
end


player = ARGV[0] ||= 'day_trader'
host = ARGV[1] ||= 'localhost'
port = ARGV[2] ||= 3000

connection = Client.new(host,port)
puts connection.register("#{player}")

counter = 0
listed = Stock.new(connection) # get available stocks and prices

while true
    
  listed.display_status(connection,counter)
  counter += 1
  sleep 2
  
end


