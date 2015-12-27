# Module providing encapsulation of common docker cli interaction
module DockerExecModule
  def blc(command)
    ['/bin/bash', '-lc', command]
  end
end
