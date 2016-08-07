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
          message = Message.read(sock)
          next if message.nil?

          method = message["method"].not_nil!
          params = message["params"]

          case method
          when "ping"
            Message.write(sock, { result: "PONG", error: nil })
          when "list"
            payload = ProcessRegistry.instance.all.map do |p|
              { name: p.name, pid: p.pid, state: p.state, respawns: p.respawns }
            end
            Message.write(sock, { result: payload, error: nil })
          else
            Message.write(sock, { result: "BAR", error: nil })
          end

          sock.close
        end
      end
    end
  end
end
