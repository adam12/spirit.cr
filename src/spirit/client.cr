require "socket/unix_socket"

module Spirit
  class Client
    def initialize(@socket_file : String)
    end

    def ping
      with_socket do |sock|
        sock.puts "PING"
        sock.gets.not_nil!.strip == "PONG"
      end
    end

    def list
      with_socket do |sock|
        sock.puts "LIST"
        sock.gets
      end
    end

    def rescan
      with_socket do |sock|
        sock.puts "RESCAN"
      end
    end

    def status(process_name)
      with_socket do |sock|
        sock.puts "STATUS #{process_name}"
        sock.gets
      end
    end

    def start(process_name)
      with_socket do |sock|
        sock.puts "START #{process_name}"
        sock.gets
      end
    end

    def stop(process_name)
      with_socket do |sock|
        sock.puts "STOP #{process_name}"
        sock.gets
      end
    end

    def restart(process_name)
      with_socket do |sock|
        sock.puts "RESTART #{process_name}"
        sock.gets
      end
    end

    def log(process_name)
      with_socket do |sock|
        sock.puts "LOG #{process_name}"
        sock.gets
      end
    end

    def tail(process_name)
      with_socket do |sock|
        sock.puts "TAIL #{process_name}"
        sock.gets
      end
    end

    def with_socket
      UNIXSocket.open(@socket_file) do |sock|
        yield sock
      end
    end
  end
end
