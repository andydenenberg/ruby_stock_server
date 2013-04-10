require 'spec_helper'

require 'market_beat'

describe 'Market' do
  
  before :each do
    Stock.add('ibm',211)
    Stock.add('goog',685)
  end
  
  it 'should get the latest stock price' do
    (MarketBeat.last_trade_real_time :AAPL ).to_f.should be_a(Float)
  end
  
  it 'should get the date of the latest stock price' do
    (MarketBeat.last_trade_datetime_real_time :AAPL ).should be_a(String)
  end

end