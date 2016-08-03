module Spirit
  class Message
    def self.write(socket, message)
      socket.write_bytes(message.size, IO::ByteFormat::BigEndian)
      socket.print(message)
    end

    def self.read(socket)
      length = socket.read_bytes(Int32, IO::ByteFormat::BigEndian)
      socket.gets(length)
    end
  end
end
