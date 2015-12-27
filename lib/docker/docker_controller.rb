require 'docker'
require_relative 'xz_generator'
require 'io/console'
require_relative 'wp_site'
require_relative 'docker_exec_module'
require_relative 'docker_containers'
require_relative 'selenium_container'
require_relative 'php_container'
require_relative 'docker_networking_module'

# Class handling all Docker interaction
class DockerController
  include XZGen
  include DockerExecModule
  include StringModule
  include DockerNetworking

  def initialize(config_handler)
    @config_handler = config_handler
    @containers = {}
    @image_catalog = {
      data: { DATA_IMAGE => { '/' => DATA_BUILD_PATH } },
      db: { DB_IMAGE => { '/' => DB_BUILD_PATH } },
      nginx: { NGINX_IMAGE => { '/' => NGINX_BUILD_PATH } },
      php: { PHP_IMAGE => { '/' => PHP_BUILD_PATH,
                            '/plugins' => SUBJECT_WP_PLUGIN_PATH} },
      selenium: { SELENIUM_IMAGE => { '/' => SELENIUM_BUILD_PATH } },
    }
    @container_catalog = {
      data: { Image: DATA_IMAGE,
              Tty: true,
              HostConfig: port_settings_hash([RSYNC_INTERNAL_PORT]) }
    }
  end

  def public_port(container_index, port)
    if docker_on_socket?
      port
    else
      container(container_index)
        .json['NetworkSettings']['Ports']["#{port}/tcp"][0]['HostPort']
    end
  end

  def selenium_host
    ip = remote_ip(:selenium)
    port = public_port(:selenium, SELENIUM_INTERNAL_PORT)
    "http://#{ip}:#{port}/wd/hub"
  end

  def start_basic_containers
    start_containers [:data]
    Rsync.configure do |config|
      config.host = 'rsync://root@' + remote_ip(:data)
    end
    data_container_name = container_name(:data)
    @container_catalog[:db] =
      { Image: DB_IMAGE,
        HostConfig:
          port_settings_hash([DB_INTERNAL_PORT])
          .merge(VolumesFrom: [data_container_name]) }
    start_containers [:db]
    @container_catalog[:nginx] = { Image: NGINX_IMAGE,
                                   HostConfig:
                                     port_settings_hash(%w(80 443))
                                     .merge(host_config) }
    start_containers [:nginx]
    @container_catalog[:php] =
      PhpContainer.new(self, @config_handler).run_configuration
    @container_catalog[:selenium] = selenium_instance.run_configuration
    start_containers [:php, :selenium]
    wp_site.install
  end

  # @return[SeleniumContainer]
  def selenium_instance
    SeleniumContainer.new(self, @config_handler)
  end

  def wp_site
    WPSite.new(container(:php),
               container(:nginx),
               WP_INSTALL_PATH,
               WP_DEFAULT_DOMAIN)
  end

  def delete_containers
    RunnerCli.new(wp_site).handle_finish if @config_handler.ask_finish?
    cached = @config_handler.cached_images
    @containers.each do |index, cont|
      if cached.include?(index.to_s)
        @config_handler.cache_container_id(index, cont)
      else
        cont.delete(force: true, v: true)
      end
    end
  end

  def remote_ip(index)
    if docker_on_socket?
      container(index).json['NetworkSettings']['IPAddress']
    else
      url = ENV['DOCKER_URL'] || ENV['DOCKER_HOST']
      url.match(%r{^tcp://(.+):})[1]
    end
  end

  def container(index)
    unless @containers[index]
      cont_id = 'ph'
      until @containers[index] || !cont_id
        cont_id = @config_handler.cached_container_id(index.to_s)
        next unless cont_id
        container_cached = nil
        unless Docker::Container
               .all(all: true, filters: { id: [cont_id] }.to_json).empty?
          container_cached = Docker::Container.get(cont_id)
        end
        if container_cached && !container_cached.json['State']['Running']
          container_cached.delete(force: true, v: true)
          DockerContainers.find_by(docker_id: cont_id).destroy
        end
        if container_cached
          @containers[index] = container_cached
        else
          DockerContainers.find_by(docker_id: cont_id).destroy
        end
      end
      unless @containers[index]
        build_images [index], true
        @containers[index] = Docker::Container.create(@container_catalog[index])
      end
    end

    @containers[index]
  end

  def container_name(index)
    container(index).json['Name'].reverse.chomp('/').reverse
  end

  private

  def docker_on_socket?
    !(ENV['DOCKER_URL'] && ENV['DOCKER_URL'].match(%r{^tcp://(.+):})) ||
      !(ENV['DOCKER_HOST'] && ENV['DOCKER_HOST'].match(%r{^tcp://(.+):}))
  end

  def wait_on_port(port, ip = '127.0.0.1')
    container(:php).exec blc("./wait.sh #{ip} #{port}")
  end

  def build_images(indexes, rebuild = false)
    cached = @config_handler.cached_images
    indexes.each do |index|
      image, paths = @image_catalog[index].first
      next if !rebuild &&
              cached.include?(index.to_s) && Docker::Image.exist?(image)
      xz_string = xz(paths)
      puts('Need to upload ' +
             (xz_string.length.to_f / 100_000_0).to_s +
             'MB to the docker server in order to build: ' + image)
      Docker::Image.build_from_tar(StringIO.new(xz_string))
        .tag('repo' => image, 'tag' => 'latest', force: true)
    end
  end

  def host_config
    { VolumesFrom: [container_name(:data)],
      Links: [container_name(:db) + ':' + DB_INTERNAL_HOSTNAME],
      ExtraHosts: (nginx_domains.map { |e| e + ':127.0.0.1' }) }
  end

  def container_for(index, container)
    @containers[index] = container
  end

  def start_containers(containers)
    containers.each do |cont|
      container = container(cont)
      container.start unless container.json['State']['Running']
      @config_handler.cache_container_id(cont, container)
    end
  end
end
