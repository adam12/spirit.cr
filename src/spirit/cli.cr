require "./process"
require "./daemon"
require "./client"
require "./commands/list"

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
        Daemon.new("./socket").run
      when "list"
        Spirit::Commands::List.new("./socket").execute
      when "rescan"
        pp Client.new("./socket").rescan
      when "ping"
        pp Client.new("./socket").ping
      when "help"
        display_help
      end
    end

    def parse_process_command
      process_name = @argv[0]

      case @argv[1]
      when "status"
        pp Client.new("./socket").status(process_name)
      when "start"
        pp Client.new("./socket").start(process_name)
      when "stop"
        pp Client.new("./socket").stop(process_name)
      when "restart"
        pp Client.new("./socket").restart(process_name)
      when "log"
        pp Client.new("./socket").log(process_name)
      when "tail"
        pp Client.new("./socket").tail(process_name)
      end
    end

    def display_help
      puts "Help"
    end
  end
end

Spirit::CLI.new(ARGV).run
