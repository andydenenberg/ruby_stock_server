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
