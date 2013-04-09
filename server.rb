# original erlang/elixir version
# https://github.com/ekosz/stock_server

require 'socket'                # Get sockets from stdlib

class Stock
  # Repository of tradeable stocks
  @@stocks = { }
  
  def self.list
    @@stocks.collect { |symbol,price| [ symbol.upcase , ' '] }.flatten.join.strip
  end
  
  def self.add(symbol,price)
    @@stocks[symbol.upcase] = price
  end  
  
  def self.price(symbol)
    @@stocks[symbol.upcase]
  end  
  
  def self.update_price(symbol,price)
    valid_price?(price) ? ( @@stocks[symbol.upcase] = price ) : nil
  end
  
  def self.valid_price?(price)
    price.to_s.match(/^[-+]?[0-9]*\.?[0-9]+$/)
  end
  
end

class Portfolio
  # A portfolio instance is created for each player that is registered
  attr_accessor :cash, :stocks, :name
  
  def initialize(name)
    @name = name
    @cash = 100000 
    @stocks = [ ]
  end
  
  def current_stocks
    @stocks.collect { |symbol,quantity| [symbol.upcase, ' ', quantity, ' '] }.flatten.join.strip
  end
  
  def buy(symbol,quantity)
      return "ERROR #{symbol.upcase} is an invalid symbol" if !valid_symbol?(symbol)
      current_price = Stock.price(symbol)
      cost = current_price * quantity
      return "ERROR Only $#{@cash} available - $#{cost} required" if @cash < cost
      @cash -= cost
      position = shares_held(symbol)
      position.nil? ? ( @stocks.push [ symbol, quantity ] ) : update_shares(symbol, quantity)
      "OK BOUGHT #{symbol.upcase} #{quantity} #{current_price}"
  end
  
  def sell(symbol,quantity)
      return "ERROR #{symbol.upcase} is an invalid symbol" if !valid_symbol?(symbol)
      position = shares_held(symbol)
      return "No shares in #{symbol.upcase} to sell" if position.zero? or position.nil?
      return "ERROR Cannot sell #{quantity} - only #{position} shares held" if position < quantity
      current_price = Stock.price(symbol)
      update_shares(symbol, -quantity)
      @cash += current_price * quantity
      "OK SOLD #{symbol.upcase} #{quantity} #{current_price}"
  end

  private
    def find_stock(symbol)
      @stocks.select { |sym,quan| sym == symbol }
    end
    
    def valid_symbol?(symbol)
      Stock.price(symbol)
    end
    
    def shares_held(symbol)
      stock = @stocks.select { |sym,quan| sym == symbol }
      stock.empty? ? (return nil) : (return stock[0][1])
    end
    
    def update_shares(symbol,quantity)
      stock = @stocks.select { |sym,quan| sym == symbol }
      stock[0][1] += quantity
    end
    
end

class Player
  # Repository of players
  # Each player is identified by a tag that is created from their unique address:socket
  @@players = [ ]
  
  def self.scorecard
    @@players.collect { |portfolio,tag| [ portfolio.name, portfolio.cash ] }
  end
  
  def self.register(name,tag) 
    @@players.push [ Portfolio.new(name), tag ]
    "OK registered"
  end
  
  def self.quit(tag)
    @@players.delete_if { |portfolio,id| id == tag }
    "Goodbye"
  end
 
  def self.portfolio(tag)
    player = @@players.find { |portfolio,id| id == tag }
    player ? player[0] : nil
  end
      
end

class Command
  
  def self.process(input,tag,logging = false)
    
    portfolio = Player.portfolio(tag)      
          
    if logging
      log = "command:#{input}"      
      log << " name:#{portfolio.name} tag:#{tag}" if portfolio
      puts log
    end

    case input[0]
    when 'quit'
      return "#{Player.quit(tag)}"
    when 'register' 
      return "#{Player.register(input[1], tag)}"
    when 'list_stocks'        
      return "OK #{Stock.list}"
    when 'current_cash'
      return "OK #{portfolio.cash.to_s}" if portfolio
    when 'current_stocks'
      return "OK #{portfolio.current_stocks}" if portfolio    
    when 'price'
      return "OK #{Stock.price(input[1])}"
    when 'buy'     
      return portfolio.buy(input[1],input[2].to_i) if portfolio
    when 'sell'
      return portfolio.sell(input[1],input[2].to_i) if portfolio
    else
      return 'Bad Command'
    end     
  end
  
end

class Server
  
  def self.run(logging = false, scorecard = true)
    server = TCPServer.open(2000)   # Socket to listen on port 2000
    puts 'server started'
    loop {                          # Servers run forever
      Thread.start(server.accept) do |client|
        puts "connection request by #{client} from #{server}"    
        while line = client.gets   # Read lines from the socket
          line = line.chop.split(' ')
          command = Command.process(line,create_tag(client),logging)
          client.puts command
          puts show_scorecard if scorecard
        end
     	  client.puts "Closing the connection. Bye!"
        client.close                # Disconnect from the client
      end
    }
  end  
  
  private
  
  def self.create_tag(client)
    sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
    "#{remote_ip}:#{remote_port}"  
  end
  
  def self.show_scorecard
    sc = "\e[H\e[2J" # clear screen
    Player.scorecard.each { |player| sc << "Player: #{player[0]} Cash: $#{player[1].to_s.reverse.gsub(/...(?=.)/,'\&,').reverse}\n"}
    sc 
  end
  
end

if __FILE__ == $0
  Stock.add('aapl',425)
  Stock.add('ibm',211)
  Stock.add('goog',685)

 Server.run
end
