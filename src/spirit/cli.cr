require "./process"
require "./daemon"
require "./client"
require "./commands/list"
require "./commands/status"
require "./commands/start"
require "./commands/stop"
require "./commands/restart"

module Spirit
  class CLI
    def initialize(@argv : Array(String))
      @socket_file = "./socket"
    end

    def run
      case @argv.size
      when 1
        parse_instance_command(@argv[0])
      when 2
        parse_process_command(@argv[0], @argv[1])
      else
        display_help
      end
    end

    def parse_instance_command(command)
      case command
      when "daemon"
        Daemon.new(@socket_file).run
      when "list"
        Spirit::Commands::List.new(@socket_file).execute
      when "rescan"
        pp Client.new(@socket_file).rescan
      when "ping"
        pp Client.new(@socket_file).ping
      when "help"
        display_help
      end
    end

    def parse_process_command(process_name, command)
      case command
      when "status"
        Spirit::Commands::Status.new(@socket_file).execute(process_name)
      when "start"
        Spirit::Commands::Start.new(@socket_file).execute(process_name)
      when "stop"
        Spirit::Commands::Stop.new(@socket_file).execute(process_name)
      when "restart"
        Spirit::Commands::Restart.new(@socket_file).execute(process_name)
      when "log"
        pp Client.new(@socket_file).log(process_name)
      when "tail"
        pp Client.new(@socket_file).tail(process_name)
      end
    end

    def display_help
      puts "Help"
    end
  end
end

Spirit::CLI.new(ARGV).run
