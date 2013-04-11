require 'spec_helper'

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
      @portfolio.buy('GE', 10).should eql "ERROR GE is an invalid symbol"
    end
    
    it 'should detect if there is sufficient cash to buy the stock' do
      @portfolio.buy('aapl', 1000).should eql "ERROR Only $100000 available - $415000 required"
    end

    it 'should allow valid stocks to be purchased' do
      @portfolio.buy('aapl', 10).should eql "OK BOUGHT AAPL 10 415"
    end
    
    it 'should calculate the Total Value' do
      Stock.update_price('aapl',425)
      value = @portfolio.total_value
      Stock.update_price('aapl', 415) # revert back to original price for subsequent tests
      value.should eql 100100
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
