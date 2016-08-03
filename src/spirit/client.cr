require "socket/unix_socket"
require "./message"

module Spirit
  class Client
    def initialize(@socket_file : String)
    end

    def ping
      with_socket do |sock|
        Message.write(sock, "PING")
        Message.read(sock) == "PONG"
      end
    end

    def list
      with_socket do |sock|
        Message.write(sock, "LIST")
        Message.read(sock)
      end
    end

    def rescan
      with_socket do |sock|
        Message.write(sock, "RESCAN")
        Message.read(sock)
      end
    end

    def status(process_name)
      with_socket do |sock|
        Message.write(sock, "STATUS #{process_name}")
        Message.read(sock)
      end
    end

    def start(process_name)
      with_socket do |sock|
        Message.write(sock, "START #{process_name}")
        Message.read(sock)
      end
    end

    def stop(process_name)
      with_socket do |sock|
        Message.write(sock, "STOP #{process_name}")
        Message.read(sock)
      end
    end

    def restart(process_name)
      with_socket do |sock|
        Message.write(sock, "RESTART #{process_name}")
        Message.read(sock)
      end
    end

    def log(process_name)
      with_socket do |sock|
        Message.write(sock, "LOG #{process_name}")
        Message.read(sock)
      end
    end

    def tail(process_name)
      with_socket do |sock|
        Message.write(sock, "TAIL #{process_name}")
        Message.read(sock)
      end
    end

    def with_socket
      UNIXSocket.open(@socket_file) do |sock|
        yield sock
      end
    end
  end
end
