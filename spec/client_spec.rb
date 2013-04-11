require 'spec_helper'

describe Trader do
  
  describe 'Trading Environment' do
   
   it 'initially contains cash and no stocks' do
     trader = Trader.new(100000)
     trader.stocks.should eql [ ]
     trader.cash.should eql 100000
   end
   
  end

end
