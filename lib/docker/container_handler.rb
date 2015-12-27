require_relative 'docker_networking_module'

# Superclass for encapsulating individual container interaction
class ContainerHandler
  include DockerNetworking
  include DockerExecModule
  include StringModule

  def initialize(docker_controller, config_handler)
    @docker_controller = docker_controller
    @config_handler    = config_handler
  end

  def run_command(command, opts = {}, &block)
    @docker_controller.container(index).exec command, opts, &block
  end

  def index
    fail 'Error container without index implemented!'
  end
end
