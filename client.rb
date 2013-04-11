class Client

  def initialize(host, port)
    @socket = TCPSocket.new(host, port)
  end

  def close
    @socket.close
  end

  def register(name)
    send_command("register #{name}")
  end

  def list_stocks
    send_command("list_stocks")
  end

  def current_cash
    send_command("current_cash")
  end

  def current_stocks
    send_command("current_stocks")
  end

  def price(ticker)
    send_command("price #{ticker}")
  end

  def buy(ticker, amount)
    send_command("buy #{ticker} #{amount}")
  end

  def sell(ticker, amount)
    send_command("sell #{ticker} #{amount}")
  end

#  private

  def send_command(command)
    @socket.puts(command)
    @socket.gets
  end
end
