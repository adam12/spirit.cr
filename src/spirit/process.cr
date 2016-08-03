module Spirit
  class Process
    @name : String
    @pid : Int32
    @started_at : Time
    @respawns : Int32
    @state : String
    @exec : String
    @working_directory : String
    @config_file : String

    # log
    # export
    # restart signal
    # stop signal

    def initialize(@name)
      @pid = 10
      @started_at = Time.now
      @respawns = 0
      @state = "stopped"
      @exec = "./foobar"
      @working_directory = "~"
      @config_file = "foo.conf"
    end

    def uptime
      @started_at - Time.now
    end

    def stale?
      # started at > file mtime => reload
    end

    def self.find_with_name(name)
      name != "foo"
    end

    def self.new_from_file(file)

    end
  end
end
