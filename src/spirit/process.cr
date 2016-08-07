require "ini"

module Spirit
  class Process
    getter exec, name, working_directory, state, respawns
    setter state

    @name : String
    @started_at : Time?
    @respawns = 0
    @state = "stopped"
    @exec : String
    @working_directory = "/"
    @config_file : String
    @status : ::Process::Status?
    @process : ::Process

    def initialize(@name, @exec, @config_file)
      @name = File.basename(@name, ".conf")
      @process = start
    end

    def uptime
      @started_at - Time.now
    end

    def stale?
      return if @started_at.nil?

      @started_at > File.lstat(@config_file).mtime
    end

    def wait
      @status ||= @process.wait
    end

    def pid
      @process.pid
    end

    def run
      yield @process.output, @process.error
    end

    def stop
      ::Process.kill(Signal::TERM, pid)
      @state = "stopped"
    end

    def start
      @state = "running"
      @process = ::Process.new(exec, chdir: working_directory, shell: true, input: false, output: nil, error: nil)
    end

    def restart
      stop
      start
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
