require 'spec_helper'

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
