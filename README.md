Ruby Stock Trading Server
===========================

This is a ruby version of Eric Koslow's Elixir/Erlang Stock Trading Server

https://github.com/ekosz/stock_server

The socket communications and commands are identical to Eric's version and are copied here.  The code and tests are complete except for price setting logic.  Currently the prices are set when the stocks are added, but not updated.  An interesting approach would be to wire up a pricing engine tied to real-time market activity.  Maybe using the Marketbeat GEM - https://github.com/michaeldv/market_beat

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