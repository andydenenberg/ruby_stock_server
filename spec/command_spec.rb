require 'spec_helper'

describe Command do
  describe 'Command controller' do
    
    context 'respond to valid commands' do
      before :all do
        Stock.add('ibm',211)
        Stock.add('goog',685)
        Stock.add('aapl',415)
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
      
