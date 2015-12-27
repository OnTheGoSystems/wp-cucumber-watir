$LOAD_PATH << File.dirname(__FILE__) + '/../../lib'

require_relative 'config_loader'
DOCKER_RES_PATH = 'res/docker/'
TEST_START_TIME_STAMP = Time.now.to_i.to_s
OUTPUT_PATH = 'tmp/test_results'
CONTAINER_CACHE = 'tmp/containers'
FileUtils.rmtree OUTPUT_PATH
FileUtils.mkdir_p OUTPUT_PATH
FileUtils.mkdir_p CONTAINER_CACHE
WP_DEFAULT_DOMAIN = 'cleanwp.dev'
WP_DEFAULT_URL = 'http://' + WP_DEFAULT_DOMAIN
WP_INSTALL_PATH = '/www/' + WP_DEFAULT_DOMAIN
$config_loader = ConfigLoader.new 'config.yml'
config_loader = $config_loader
config_loader.load_config_file
SUBJECT_WP_PLUGIN_PATH = config_loader.host_wp_plugin_path
ENV['DOCKER_URL'] = config_loader.docker_host
USER_EMAIL_DOMAIN = 'mailinator.com'
WP_ADMIN_USERNAME = 'Admin'
WP_ADMIN_PASSWORD = 'test'
WP_DATABASE = WP_DEFAULT_DOMAIN
DEFAULT_WP_THEME = 'twentysixteen'
DATABASE_USER = 'root'
DATABASE_PASSWORD = 'root'
DB_INTERNAL_HOSTNAME = 'db'
RANDOM_POST_TAG_COUNT = 3
require_relative 'docker_env'
DB_INTERNAL_PORT = '3306'
RSYNC_INTERNAL_PORT = '873'
SELENIUM_INTERNAL_PORT = '4444'
WP_INTERNAL_PORT = '80'
BROWSER_WIDTH = 1600
BROWSER_HEIGHT = 1200
FIREFOX_DETECT_ALERT_MAX_DELAY = 15
require 'rsync'
require 'mysql2'
require 'active_record'
require_relative '../../lib/docker/docker_controller'
require_relative '../../lib/user_interface/runner_cli'
$docker_controller = DockerController.new config_loader
docker_controller = $docker_controller
Excon.defaults[:write_timeout] = 100_000_0
Excon.defaults[:read_timeout] = 100_000_0
docker_controller.start_basic_containers
DATABASE_HOST = docker_controller.remote_ip(:db)
DATABASE_PORT = docker_controller.public_port :db, DB_INTERNAL_PORT

dbs = { wp: WP_DATABASE }

require 'database_cleaner'
require 'database_cleaner/cucumber'

dbs.each_pair do |key, database|
  ActiveRecord::Base.configurations[key.to_s] = {
    adapter: 'mysql2',
    host: DATABASE_HOST,
    port: DATABASE_PORT,
    username: DATABASE_USER,
    password: DATABASE_PASSWORD
  }.merge(database: database)
end

require 'require_all'
require 'watir-webdriver'
require 'page-object'
require_relative 'wp_world_helpers'
require_relative 'test_step_data'
require_all 'lib'

$test_reporter = WatirTestReporter.new docker_controller

World(PageObject::PageFactory)
World(WpWorldHelpers)
World(TestStepData)