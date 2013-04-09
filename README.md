Ruby Stock Trading Server
===========================

This is a ruby version of Eric Koslow's Elixir/Erlang Stock Trading Server

https://github.com/ekosz/stock_server

The socket communications and commands are identical to Eric's version and are copied here.  The code and tests are complete except of price setting logic.  Currently the prices are set when the stocks are added, but not updated.  An interesting approach would be to wire up a pricing engine tied to real-time market activity.  Maybe using the Marketbeat GEM - https://github.com/michaeldv/market_beat

Andy 04/08/2013

```