require "socket"
require "socket/unix_server"
require "./message"

module Spirit
  class Daemon
    def initialize(@socket_file : String)
    end

    def run
      puts "Daemon"

      server = UNIXServer.new(@socket_file)

      while (sock = server.accept)
        spawn do
          line = Message.read(sock)
          parts = line.not_nil!.split(" ")
          command = parts[0]
          arguments = parts[1..-1]

          pp command, arguments

          case command
          when "PING"
            Message.write(sock, "PONG")
          else
            Message.write(sock, "BAR")
          end

          sock.close
        end
      end
    end
  end
end
