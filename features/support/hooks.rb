Before do |scenario|
  caps = Selenium::WebDriver::Remote::Capabilities.firefox(
    unexpectedAlertBehaviour: 'ignore')
  @admin = { login_name: WP_ADMIN_USERNAME,
             password: WP_ADMIN_PASSWORD,
             email: 'test@test.dev' }
  @docker_controller = $docker_controller
  @browser = Watir::Browser.new(
    :remote,
    url: @docker_controller.selenium_host,
    desired_capabilities: caps)
  @browser.window.move_to(0, 0)
  @browser.window.resize_to(BROWSER_WIDTH, BROWSER_HEIGHT)
  @wp_install_helper = WpInstallationHelper.new @browser, @docker_controller
  unless ENV['NO_REPORT']
    @docker_controller.selenium_instance.start_recording scenario
  end
  @wp_site = @docker_controller.wp_site
end

After do |scenario|
  if scenario.failed?
    sleep 2
    # sleep 2 seconds so that you can see what happened in the video later on
    $test_reporter.post_scenario_fail @browser, scenario unless ENV['NO_REPORT']
  elsif !ENV['NO_REPORT']
    if ENV['FORCE_VIDEO']
      $test_reporter.save_video(scenario)
    else
      @docker_controller.selenium_instance.discard_video(scenario)
    end
    $test_reporter.save_export(scenario) if ENV['FORCE_EXPORT']
  end
  @browser.close
end

at_exit do
  $test_reporter.post_results
  $docker_controller.delete_containers
end
