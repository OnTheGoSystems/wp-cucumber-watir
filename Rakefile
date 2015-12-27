require 'cucumber'
require 'cucumber/rake/task'
require_relative 'features/support/config_loader'

Cucumber::Rake::Task.new(:migration) do |t|
  t.profile = 'migration'
end

Cucumber::Rake::Task.new(:wcml) do |t|
  t.profile = 'wcml'
end

Cucumber::Rake::Task.new(:layouts) do |t|
  t.profile = 'layouts'
end

Cucumber::Rake::Task.new(:string_packages) do |t|
  t.profile = 'string_packages'
end

Cucumber::Rake::Task.new(:all) do |t|
  t.profile = 'all'
end

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
