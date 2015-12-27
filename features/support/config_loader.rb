require 'yaml'

# Class handling the config file
class ConfigLoader

  def initialize(config_file_path)
    @config_file_path = config_file_path
  end

  def load_config_file
    @config = YAML.load_file(@config_file_path) if File.exist? @config_file_path
  end

  def host_wp_plugin_path
    @config['wp_plugin_dir'] || (
    if ENV['SUBJECT_WP_PATH']
      ENV['SUBJECT_WP_PATH']
    else
      WP_INSTALL_PATH
    end)
  end

  def docker_host
    @config['docker_host'] || ENV['DOCKER_URL'] || ENV['DOCKER_HOST']
  end

  def php_version
    @config['php_version'] || '5.6'
  end

  def cached_images
    @config['cached_images'] = [] if ENV['WATIR_NO_CACHE']

    @config['cached_images'] || []
  end

  def compress_streams?
    @config['compress_streams']
  end

  def xdebug_host
    @config['xdebug_host']
  end

  def use_standard_ports?
    @config['use_standard_ports']
  end

  def ask_finish?
    @config['ask_finish']
  end

  def cached_container_id(index)
    res = DockerContainers.order(created_at: :desc).find_by(index: index.to_s)

    res ? res.docker_id : nil
  end

  def cache_container_id(index, container)
    DockerContainers.create(index: index, docker_id: container.id)
  end
end
