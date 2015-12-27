# Class handling installing WP
# TODO: this should be integrated with other code and is pointless longterm
class WpInstallationHelper
  def initialize(browser, docker_handler)
    @browser        = browser
    @docker_handler = docker_handler
  end

  def install_site(path, domain, multisite = false)
    @browser.cookies.clear
    wp_site = WPSite.new(@docker_handler.container(:php),
                         @docker_handler.container(:nginx),
                         path,
                         domain)
    wp_site.install multisite
  end
end
