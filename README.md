Ruby Stock Trading Server
===========================

This is a ruby version of Eric Koslow's Elixir/Erlang Stock Trading Server

https://github.com/ekosz/stock_server

The socket communications and commands are identical to Eric's version.  The major difference in function is the price for each stock is the real-time market price retrieved from Google and Yahoo finance.  As such the prices will be static except during the hours of 9:30am to 4:00pm EST M-F when the markets are open.  Eric's implementation set prices from a replay of historical data as well the effects from the system players.

The prices are retrieved using the Marketbeat GEM
https://github.com/michaeldv/market_beat

run "bundle install" and then the server can be invoked: 

```ruby
ruby server.rb   ...with defaults of ( port=3000 logging=false scorecard=true )
or with overrides...
ruby server.rb 2000 true false
```

The sample test client is provided which will register and periodically poll the server and display pricing info for all stocks and portfolio value.  By default the test client buys an equal value of all the listed stocks.

```ruby
ruby test_client.rb <player_name>   ...with defaults: (server_address="localhost" port=3000 )
override example...
ruby test_client.rb DayTrader "stockserver.denenberg.net" 2000
```

Andy 04/08/2013


```