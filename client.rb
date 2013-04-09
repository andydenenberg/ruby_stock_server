require 'socket'
require_relative 'client_commands'

def stocks_list(c)
  stocks = c.list_stocks.split(' ').collect { |stk| 
    [ stk, c.price(stk).split(' ')[1].to_f ] 
    }
  stocks.shift # drop the command "OK" from the list
  stocks
end

def display_status(stocks,c)
  puts "\e[H\e[2J" # clear screen
  stocks.each do |stock|
    new_price = c.price(stock[0]).split(' ')[1].to_f
    delta = new_price-stock[1]
    percent = 100* (delta / stock[1] )
    
    status = "%6s " % stock[0]
    status << "price:$%3.2f " % new_price
    status << "change:$%3.2f " % delta
    status << "(%3.2f" % percent + '%)'
    puts status 
  end
end

player = ARGV[0]

connection = Client.new("localhost",2000)
puts s.register("#{player}")

while true
    
  stocks = stocks_list(connection)
  display_status(stocks,connection)
  
sleep 5
end


