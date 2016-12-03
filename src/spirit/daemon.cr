require "socket"
require "socket/unix_server"
require "./message"
require "./process_registry"

module Spirit
  class Daemon
    getter channel

    def initialize(@socket_file : String)
      @channel = Channel(Int32).new
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

        process.run do |output, error|
          spawn do
            spawn do
              begin
                while process_output = output.gets
                  puts process_output
                end
              rescue ex : Errno
                puts "STDOUT closed"
              end
            end

            spawn do
              begin
                while process_error = error.gets
                  puts process_error
                end
              rescue ex : Errno
                puts "STDERR closed"
              end
            end

            # Wait for exit
            status = process.wait
            @channel.send(process.pid)
          end
        end

        ProcessRegistry.instance.register(process)
      end
    end

    # def watch_for_ended_processes
    #   if ended_pid = @channel.receive
    #     ended_process = ProcessRegistry.find_with_pid(ended_pid)

    #     if id =
    #   end
    # end

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

          when "rescan"

          when "start"
            name = params[0].as_s

            if process = ProcessRegistry.instance.find_with_name(name)
              process.start
              Message.write(sock, { result: "OK", error: nil })
            else
              Message.write(sock, { result: nil, error: "Unable to find process with name: #{name}" })
            end

          when "stop"
            name = params[0].as_s

            if process = ProcessRegistry.instance.find_with_name(name)
              process.stop
              Message.write(sock, { result: "OK", error: nil })
            else
              Message.write(sock, { result: nil, error: "Unable to find process with name: #{name}" })
            end

          when "restart"
            name = params[0].as_s

            if process = ProcessRegistry.instance.find_with_name(name)
              process.restart
              Message.write(sock, { result: "OK", error: nil })
            else
              Message.write(sock, { result: nil, error: "Unable to find process with name: #{name}" })
            end

          when "status"
            name = params[0].as_s

            if process = ProcessRegistry.instance.find_with_name(name)
              Message.write(sock, { result: process.state, error: nil })
            else
              Message.write(sock, { result: nil, error: "Unable to find process with name: #{name}" })
            end
          else
            Message.write(sock, { result: "BAR", error: nil })
          end

          sock.close
        end
      end
    end
  end
end
