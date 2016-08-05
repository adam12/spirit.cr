require "./process"

class ProcessRegistry
  INSTANCE = new

  @processes = [] of Spirit::Process

  def all
    @processes
  end

  def find(process)
    @processes.find {|p| p == process }
  end

  def find_with_name(name)
    @processes.find {|p| p.name == name }
  end

  def find_with_pid(pid)
    @processes.find {|p| p.pid == pid }
  end

  def register(process)
    @processes << process
  end

  def self.instance
    INSTANCE
  end
end
