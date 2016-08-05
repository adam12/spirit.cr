require "ini"

module Spirit
  class Process
    getter exec, name, working_directory

    @name : String
    @pid : Int32?
    @started_at : Time?
    @respawns = 0
    @state = "stopped"
    @exec : String
    @working_directory = "/"
    @config_file : String

    def initialize(@name, @exec, @config_file)
    end

    def uptime
      @started_at - Time.now
    end

    def stale?
      # started at > file mtime => reload
    end

    def start
      fork do
        loop do
          @started_at = Time.now

          ::Process.run(exec, chdir: working_directory) do |proc|
            pp proc
            @state = "running"
            @pid = proc.pid
          end
          # result = ::Process.new(exec, chdir: working_directory)
          # pp result
          # @state = "running"
          # @pid = result.pid

          # result.wait

          sleep 1
          @respawns += 1
        end
      end
    end

    def self.new_from_file(file)
      config = INI.parse(File.read(file))
      root = config[""]
      new(
        name: file,
        config_file: file,
        exec: root["ExecStart"]
      )
    end
  end
end
