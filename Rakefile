require 'cucumber'
require 'cucumber/rake/task'
require_relative 'features/support/config_loader'

Cucumber::Rake::Task.new(:cucumber) do |t|
  t.profile = 'default'
end

task :clean_containers do
  require 'active_record'
  require_relative 'lib/docker/docker_controller'
  config_loader = ConfigLoader.new 'config.yml'
  config_loader.load_config_file
  ENV['DOCKER_URL'] = config_loader.docker_host
  DockerContainers.cleanup_all_containers
end

task default: :cucumber
