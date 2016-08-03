require "./process"
require "./daemon"

module Spirit
  class CLI
    def initialize(@argv : Array(String))
    end

    def run
      case @argv.size
      when 1
        parse_instance_command
      when 2
        parse_process_command
      else
        display_help
      end
    end

    def parse_instance_command
      case @argv[0]
      when "daemon"
        Daemon.run
      when "list"
        # client.list
        puts "list"
      when "rescan"
        # client.rescan
        puts "rescan"
      when "help"
        display_help
      end
    end

    def parse_process_command
      process_name = @argv[0]

      case @argv[1]
      when "status"
        # client.status(process_name)
        puts "status"
      when "start"
        # client.start(process_name)
        puts "start"
      when "stop"
        # client.stop(process_name)
        puts "stop"
      when "restart"
        # client.restart(process_name)
        puts "restart"
      when "log"
        # client.log(process_name)
        puts "log"
      when "tail"
        # client.tail(process_name)
        puts "tail"
      end
    end

    def display_help
      puts "Help"
    end
  end
end

Spirit::CLI.new(ARGV).run
