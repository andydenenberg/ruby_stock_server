require 'spec_helper'

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
      Stock.list.should eql 'IBM GOOG AAPL CSCO'
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
