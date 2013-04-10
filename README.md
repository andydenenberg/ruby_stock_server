Ruby Stock Trading Server
===========================

This is a ruby version of Eric Koslow's Elixir/Erlang Stock Trading Server

https://github.com/ekosz/stock_server

The socket communications and commands are identical to Eric's version and are copied here.  The price for each stock mirrors the real-time market price retrieved from Google and Yahoo finance.  As such the prices will be static except during the hours of 9:30am to 4:00pm EST M-F when the markets are open.  Eric's implementation set prices from a replay of historical data as well the effects from the system players.

The server code and tests are complete except for price setting logic.  Currently the prices are retrieved using the Marketbeat GEM
https://github.com/michaeldv/market_beat
to get the latest quotes from Google and Yahoo.

The server can be run with defaults: ( port=3000 logging=false scorecard=true )

```ruby
ruby server.rb
or with overrides...
ruby server.rb 2000 true false
```

The sample client will register and periodically poll the server and display pricing info for all stocks.  It can be be run with defaults: (server_address="localhost" port=3000 )

```ruby
ruby client.rb <player_name>
override example...
ruby client.rb DayTrader "railsdev.denenberg.net" 2000
```

Andy 04/08/2013


```