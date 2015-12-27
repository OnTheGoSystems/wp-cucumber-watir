# Class handling the creation of report output
class WatirTestReporter
  def initialize(docker_controller)
    @docker_controller = docker_controller
  end

  def post_results
    FileUtils.mkdir_p OUTPUT_PATH
    if File.exist?(OUTPUT_PATH + 'results.html')
      FileUtils.rmtree OUTPUT_PATH + 'results.html'
    end
    FileUtils.move('results.html', OUTPUT_PATH)
    if File.exist?(OUTPUT_PATH + 'results')
      FileUtils.rmtree OUTPUT_PATH + 'results'
    end
    FileUtils.move('results', OUTPUT_PATH)
  end

  def post_scenario_fail(browser, scenario)
    FileUtils.mkdir_p(OUTPUT_PATH)
    html_file_name = OUTPUT_PATH + scenario.name.split.join('_') + '.html'

    File.write(html_file_name, browser.html)
    save_video scenario
    save_export scenario
  end

  def save_export(scenario)
    zip_file_name = OUTPUT_PATH + scenario.name.split.join('_') + '.zip'
    FileUtils.rmtree zip_file_name if File.exist?(zip_file_name)
    File.write(zip_file_name,
               WPSite.new(@docker_controller.container(:php),
                          @docker_controller.container(:nginx),
                          WP_INSTALL_PATH, WP_DEFAULT_DOMAIN).export_site(scenario),
               mode: 'wb')
  end

  def save_video(scenario)
    video_file_name = OUTPUT_PATH + scenario.name.split.join('_') + '.mp4'
    FileUtils.rmtree video_file_name if File.exist?(video_file_name)
    File.write(video_file_name,
               @docker_controller.selenium_instance.video_string(scenario),
               mode: 'wb')
  end
end
