require_relative 'docker_exec_module'
require_relative '../modules/string_module'

# Class Encapsulating a WP site or a WP Network blog
class WPSite
  include DockerExecModule
  include StringModule

  def initialize(php_container, nginx_container, path, domain, port = 80)
    @php_container = php_container
    @nginx_container = nginx_container
    @port = port.to_s
    @path = path
    @domain = domain
  end

  def install(multisite = false)
    @php_container.exec(
      blc("/newsite.sh #{@path} #{@domain} #{@port} #{DB_INTERNAL_HOSTNAME}"\
      " #{DB_INTERNAL_PORT} #{DATABASE_USER}"\
      " #{DATABASE_PASSWORD} " + (multisite ? '1' : '0')))
    @nginx_container.exec(
      blc("/newsite.sh #{@path} #{@domain} #{@port}"\
      ' ' + (multisite ? '1' : '0')))
    sync_wp_plugins
    @php_container.exec blc("/test-scripts/copy_wp_deps.sh #{@path}")
  end

  def home_url
    'http://' + @domain
  end

  def generate_posts(count, post_type)
    @php_container.exec(blc("wp post generate --path=#{@path}"\
    " --count=#{count} --post_type=#{post_type} --allow-root"))
  end

  def add_cpt(cpt)
    @php_container.exec(blc("/test-scripts/add_#{cpt}_cpt.sh"\
    " #{@domain} #{DEFAULT_WP_THEME}"))
    sleep 5
  end

  def export_site(scenario)
    filename = file_name_base(scenario) + '.zip'
    @php_container.exec(
      blc('php /export_site.php ' + @domain + ' ' + filename + ' ' + @path))
    s = ''
    @php_container.copy('/tmp/' + filename) { |chunk| s += chunk }
    export_string = ''
    Gem::Package::TarReader.new(StringIO.new(s)).seek(filename) do |file|
      export_string += file.read
    end

    export_string
  end

  def clean_log
    @php_container.exec blc("> #{log_path}")
  end

  def log_file
    output = ''
    [['touch', log_path],
     ['cat', log_path]].each do |cmd|
      output += @php_container.exec(cmd).shift.shift.to_s
    end
    output.strip!
    output
  end

  def sync_wp_plugins
    Rsync.run(SUBJECT_WP_PLUGIN_PATH,
              '/data/',
              %w(-r -z -a --delete --usermap=root:root))
    ip = $docker_controller.remote_ip(:data)
    @php_container.exec blc("rsync -avr --delete rsync://root@#{ip}/data/plugins #{@path}/wp-content")
    @nginx_container.exec blc("rsync -avr --delete rsync://root@#{ip}q/data/plugins #{@path}/wp-content")
  end

  private

  def log_path
    @path + '/wp-content/debug.log'
  end
end
