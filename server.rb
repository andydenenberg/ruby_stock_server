# original erlang/elixir version
# https://github.com/ekosz/stock_server

require 'market_beat'
require 'socket'  # Get sockets from stdlib
require_relative 'stock'
require_relative 'portfolio'
require_relative 'player'
require_relative 'command'

class Server
  
  def self.run(port = 3000, logging = false, scorecard = true)
      puts 'refreshing prices'
    Stock.refresh_prices
    server = TCPServer.open(port) # start listening
      puts 'server started'
    start_time = Time.now
    Thread.new { Stock.update_all(10) } # refresh prices every 10 seconds    
    loop {                          # Servers run forever
      Thread.start(server.accept) do |client|
        while line = client.gets   
          line = line.chop.split(' ')
          command = Command.process(line,create_tag(client),logging)
          client.puts command
          puts show_scorecard(start_time) if scorecard
        end
     	  client.puts "Closing the connection. Bye!"
        client.close                # Disconnect from the client
      end
    }
  end  
  
  def self.create_tag(client)
    sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
    "#{remote_ip}:#{remote_port}"  
  end
  
  def self.show_scorecard(start_time)
    sc = "\e[H\e[2J" # clear screen
    sc << "Elasped time: %3.1f secs. \n" % (Time.now - start_time)
    Player.scorecard.each { |player| 
      sc << "Player:#{player[0]}"
      sc << " Total:$#{player[2].to_s.reverse.gsub(/...(?=.)/,'\&,').reverse}"
      sc << " Cash:$#{player[1].to_s.reverse.gsub(/...(?=.)/,'\&,').reverse}\n" }
    sc 
  end
  
end

if __FILE__ == $0
  
  Stock.add('aapl',nil)
  Stock.add('ibm',nil)
  Stock.add('goog',nil)
  Stock.add('ge',nil)

  port = ARGV[0] ||= 3000
  logging = ARGV[1] ||= false
  scorecard = ARGV[2] ||= true
  
 Server.run port, logging, scorecard
end
