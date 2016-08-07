require "../client"

module Spirit
  module Commands
    class Start
      def initialize(@socket_file : String)
      end

      def execute(process_name)
        response = Client.new(@socket_file).start(process_name)

        if response && (result = response["result"])
          puts result
        elsif response && (error = response["error"])
          STDERR.puts error
        end
      end
    end
  end
end
