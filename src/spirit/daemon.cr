require "socket"
require "socket/unix_server"
require "./message"
require "./process_registry"

module Spirit
  class Daemon
    def initialize(@socket_file : String)
    end

    def run
      puts "Daemon"

      load_process_configs

      server = UNIXServer.new(@socket_file)
      accept_connections(server)
    end

    def load_process_configs
      Dir.glob("./config/*.conf") do |config_file|
        process = Spirit::Process.new_from_file(config_file)
        ProcessRegistry.instance.register(process)

        process.start
        pp process
      end
    end

    def accept_connections(server)
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
          when "LIST"
            Message.write(sock, ProcessRegistry.instance.all.inspect)
          else
            Message.write(sock, "BAR")
          end

          sock.close
        end
      end
    end
  end
end
