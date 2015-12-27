require_relative 'container_handler'

# Encapsulation for PHP interaction
class PhpContainer < ContainerHandler
  def run_configuration
    { Image: PHP_IMAGE,
      Env: [],
      HostConfig: {
        VolumesFrom: [@docker_controller.container_name(:data)],
        NetworkMode: 'container:' + @docker_controller.container_name(:nginx)
      } }
  end

  def index
    :php
  end
end
