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
      r, w = IO.pipe

      child = fork do
        r.close

        loop do
          ::Process.run(exec, chdir: working_directory) do |proc|
            w.puts("running")
          end

          sleep 1 # Dont' respawn too quickly
          @respawns += 1
        end
      end

      @started_at = Time.now
      @state = "running"
      @pid = child.pid

      Signal::INT.trap do
        child.kill
      end

      spawn do
        while (line = r.gets)
          pp line
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
