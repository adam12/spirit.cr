require "../client"

module Spirit
  module Commands
    class List
      def initialize(@socket_file : String)
      end

      def execute
        response = Client.new(@socket_file).list

        if response && (result = response["result"])
          puts "name\tpid\tstate\trespawns"

          result.each do |process|
            name = process["name"]
            pid = process["pid"]
            state = process["state"]
            respawns = process["respawns"]

            puts "#{name}\t#{pid}\t#{state}\t#{respawns}"
          end
        end
      end
    end
  end
end
