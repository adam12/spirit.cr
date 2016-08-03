require "socket"
require "socket/unix_server"

module Spirit
  class Daemon
    def initialize(@socket_file : String)
    end

    def run
      puts "Daemon"

      server = UNIXServer.new(@socket_file)

      while (sock = server.accept)
        spawn do
          line = sock.gets.not_nil!.strip
          parts = line.split(" ")
          command = parts[0]
          arguments = parts[1..-1]

          pp command, arguments

          case command
          when "PING"
            sock.puts("PONG")
          else
            sock.puts("Bar")
          end

          sock.close
        end
      end
    end
  end
end
