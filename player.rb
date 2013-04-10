class Player
  # Repository of players
  # Each player is identified by a tag that is created from their unique address:socket
  @@players = [ ]
  
  def self.scorecard
    @@players.collect { |portfolio,tag| [ portfolio.name, portfolio.cash ] }
  end
  
  def self.register(name,tag) 
    @@players.push [ Portfolio.new(name), tag ]
    "OK registered"
  end
  
  def self.quit(tag)
    @@players.delete_if { |portfolio,id| id == tag }
    "Goodbye"
  end
 
  def self.portfolio(tag)
    player = @@players.find { |portfolio,id| id == tag }
    player ? player[0] : nil
  end
      
end
