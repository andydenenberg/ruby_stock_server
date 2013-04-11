require 'socket'
require_relative 'client'

class Trader
  attr_accessor :stocks, :cash
  
  def initialize(cash)
    @stocks = [ ]
    @cash = cash
  end
  
  def display_status(c,start_time)
    puts "\e[H\e[2J" # clear screen
    puts "Elasped Time: #{(Time.now - start_time).to_i} secs.\n\n"
    puts " Stock    Price Shares      Value     Profit"
    total_value = update_value(c)
    @stocks.each do |symbol, old_price, new_price, cost_price, quantity |
      current = new_price * quantity
      cost = cost_price * quantity
      percent = 100 * (current / cost ) - 100
      
      status = "%6s " % symbol
      status << " $%6.2f " % new_price.to_f
      status << "%6.0f" % quantity      
      status << "  $%6.2f " % current
      status << " $%6.2f " % (current - cost)
      status << "(%3.2f" % percent + '%)'
      puts status 
    end
    puts "\nCurrent Stocks $%6.2f " % total_value
    puts "          Cash $%6.2f " % ( @cash )
    puts "         Total $%6.2f " % ( total_value + @cash )
  end
  
  def update_value(c)
    total_value = 0
      @stocks.each do |symbol, old_price, new_price, cost_price, quantity |
        old_price = new_price
        new_price = c.price(symbol)
        total_value += new_price * quantity
      end
    return total_value   
  end
    
end

class Connection
  attr_accessor :connection
  
  def initialize(player,host,port)
    @connection = Client.new(host,port)
    @connection.register("#{player}")
  end
  
  def get(command,*data)
    comdata = "#{command}"
    data.each { |d| comdata << " #{d}" }
    response = @connection.send_command(comdata).split(' ')
    response.shift # drop leading 'OK'
    response
  end
  
  def current_cash
    get('current_cash').first.to_f
  end
  
  def price(symbol)
    get('price',symbol).first.to_f
  end
  
  def list_stocks
    get('list_stocks')
  end
  
  def buy(symbol,quantity)
    get('buy',symbol,quantity)    
  end
  
end

if __FILE__ == $0

    player = ARGV[0] ||= 'day_trader'
    host = ARGV[1] ||= 'localhost'
    port = ARGV[2] ||= 3000

    c = Connection.new(player,host,port)
    listed = c.list_stocks # get available stocks
    cash = c.current_cash
    portfolio = Trader.new(cash)

    even_lot = cash / listed.count # divide cash evenly

    # purchase equal value amounts of all listed stocks
    listed.each do |symbol| 
      action, sym, quantity, cost_price = c.buy(symbol, (even_lot/c.price(symbol)).to_i)
      old_price = new_price = cost_price = cost_price.to_f
      portfolio.cash -= cost_price * quantity.to_i
      portfolio.stocks << [ symbol, old_price, new_price, cost_price, quantity.to_i ]
    end

    start_time = Time.now

    while true    
      portfolio.display_status(c,start_time)
      sleep 5
    end

end
