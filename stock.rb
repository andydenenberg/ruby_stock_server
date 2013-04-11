class Stock
  # Repository of tradeable stocks
  @@stocks = { }

  @@update_counter = 0
  def self.uc_get
    @@update_counter
  end

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
  
  def self.refresh_prices
    @@stocks.each do |symbol,price|
      update_price(symbol, MarketBeat.last_trade_real_time(symbol).to_f )
    end
  end
  
  def self.update_all(interval) # infinite loop run in a new thread
     loop {
       @@update_counter += 1
       refresh_prices
       sleep(interval)
      }
  end
  
end
