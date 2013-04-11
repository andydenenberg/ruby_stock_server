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
  
  def total_value
    total = 0
    @stocks.each do |symbol,quantity|
      total += Stock.price(symbol) * quantity
    end
    total += cash
    total
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
