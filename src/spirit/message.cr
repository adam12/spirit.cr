require "json"

module Spirit
  class Message
    def self.write(socket, message)
      serialized_message = message.to_json
      socket.write_bytes(serialized_message.size, IO::ByteFormat::BigEndian)
      socket.print(serialized_message)
    end

    def self.read(socket)
      length = socket.read_bytes(Int32, IO::ByteFormat::BigEndian)
      if serialized_message = socket.gets(length)
        JSON.parse(serialized_message)
      end
    end
  end
end
