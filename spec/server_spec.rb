require_relative '../server'

describe Stock do
  
  before :each do
    Stock.add('ibm',211)
    Stock.add('goog',685)
  end
    
  describe "Repository" do
    it 'should receive and hold a stock symbol and price' do
      Stock.add('aapl', 415).should eql 415
    end
        
    it 'should list all the stocks it has stored' do
      Stock.list.should eql 'IBM GOOG AAPL'
    end
    
    it 'should return the price for a given symbol' do
      Stock.price('aapl').should eql 415
    end
    
    it 'should accept the price of a stock to be modified' do
      Stock.update_price('aapl', 422)
      Stock.price('aapl').should eql 422
    end
    
    it 'should detect an unacceptable price' do
      Stock.update_price('aapl', "12d3").should eql nil
    end
    
  end  
end

describe Portfolio do
  before :all do
    Stock.add('aapl', 415)
    @portfolio = Portfolio.new('alpha')
  end
  
  describe "Individual Holdings" do
    it 'should hold the proper cash balance' do
      @portfolio.cash.should eql 100000
    end
    
    it 'should disallow invalid stock purchases' do
      @portfolio.buy('csco', 10).should eql "ERROR CSCO is an invalid symbol"
    end
    
    it 'should detect if there is sufficient cash to buy the stock' do
      @portfolio.buy('aapl', 1000).should eql "ERROR Only $100000 available - $415000 required"
    end

    it 'should allow valid stocks to be purchased' do
      @portfolio.buy('aapl', 10).should eql "OK BOUGHT AAPL 10 415"
    end
    
    it 'should subtract the cost of a purchase from the cash balance' do
      @portfolio.cash.should eql 100000 - 415 * 10
    end
    
    it 'should add to current existing stock position' do
      @portfolio.buy('aapl',5).should eql "OK BOUGHT AAPL 5 415"
    end
     
    it 'should accumulate stock from multiple buys and sells' do
      @portfolio.current_stocks.should eql "AAPL 15"
    end
    
    it 'should disallow invalid stock sales' do
      @portfolio.sell('qld', 10).should eql "ERROR QLD is an invalid symbol"
    end

    it 'should disallow stock sales with inadequate quantity' do
      @portfolio.sell('aapl', 16).should eql "ERROR Cannot sell 16 - only 15 shares held"
    end

    it 'should sell stock that is being held' do
      @portfolio.sell('aapl', 9).should eql "OK SOLD AAPL 9 415"
    end
    
    it 'should hold remaining stock after a sale' do
      @portfolio.current_stocks.should eql "AAPL 6"
    end

    it 'credit cash with the proceeds of a sale' do
      @portfolio.cash.should eql 100000 - 6 * 415
    end

  end
end

describe Player do
  describe 'Participants in the game' do
   
   it 'should allow a player to register' do
     Player.register('player1','192.168.0.1:3000').should eql "OK registered"
   end
   
   it 'should return a list of registered players' do
     Player.scorecard.should eql [ ['player1', 100000] ]
   end
   
   it 'should return a portfolio given an address tag' do
     portfolio = Player.portfolio('192.168.0.1:3000')
     portfolio.name.should eql 'player1'
   end

   it 'should return a list of registered players' do
     Player.scorecard.should eql [["player1", 100000]]
   end

   it 'should allow a player to deregister' do
     Player.quit('192.168.0.1:3000').should eql "Goodbye"
   end
      
  end
end

describe Command do
  describe 'Command controller' do
    
    context 'respond to valid commands' do
      before :all do
        Stock.add('csco', 21.5)
      end
      
      it 'should repond to list_stocks' do
        command = ['list_stocks']
        Command.process(command,'192.168.0.1:3000',false).should eql "OK IBM GOOG AAPL CSCO"
      end
      
      it 'should respond to register' do
        command = ['register','player2']
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK registered'
      end

      it 'should respond to current_cash' do
        command = ['current_cash']
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK 100000'
      end
      
      it 'should respond to price' do
        command = ['price','csco']
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK 21.5'
      end

      it 'should respond to buy' do
        command = ['buy','aapl',10]
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK BOUGHT AAPL 10 415'
      end

      it 'should respond to current_stocks' do
        command = ['current_stocks']
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK AAPL 10'
      end
      
      it 'should respond to sell' do
        command = ['sell','aapl',5]
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK SOLD AAPL 5 415'
      end

      it 'should display correct quantity after a sale' do
        command = ['current_stocks']
        Command.process(command,'192.168.0.1:3000',false).should eql 'OK AAPL 5'
      end
      
      it 'should respond to quit' do
        command = ['quit']
        Command.process(command,'192.168.0.1:3000',false).should eql 'Goodbye'
      end
      
  
    end
  
  end
  
end
      
