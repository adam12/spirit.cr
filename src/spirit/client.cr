require "socket/unix_socket"
require "./message"

module Spirit
  class Client
    def initialize(@socket_file : String)
    end

    def ping
      with_socket do |sock|
        Message.write(sock, { method: "ping", params: nil })
        Message.read(sock)
      end
    end

    def list
      with_socket do |sock|
        Message.write(sock, { method: "list", params: nil })
        Message.read(sock)
      end
    end

    def rescan
      with_socket do |sock|
        Message.write(sock, { method: "rescan", params: nil })
        Message.read(sock)
      end
    end

    def status(process_name)
      with_socket do |sock|
        Message.write(sock, { method: "status", params: [process_name] })
        Message.read(sock)
      end
    end

    def start(process_name)
      with_socket do |sock|
        Message.write(sock, { method: "start", params: [process_name] })
        Message.read(sock)
      end
    end

    def stop(process_name)
      with_socket do |sock|
        Message.write(sock, { method: "stop", params: [process_name] })
        Message.read(sock)
      end
    end

    def restart(process_name)
      with_socket do |sock|
        Message.write(sock, { method: "restart", params: [process_name] })
        Message.read(sock)
      end
    end

    def log(process_name)
      with_socket do |sock|
        Message.write(sock, { method: "log", params: [process_name] })
        Message.read(sock)
      end
    end

    def tail(process_name)
      with_socket do |sock|
        Message.write(sock, { method: "tail", params: [process_name] })
        Message.read(sock)
      end
    end

    def with_socket
      UNIXSocket.open(@socket_file) do |sock|
        yield sock
      end

    rescue ex : Errno
      if ex.errno == Errno::ECONNREFUSED
        STDERR.puts ex.message
        STDERR.puts "Are you sure the daemon is listening?"
        exit 1
      end
    end
  end
end
