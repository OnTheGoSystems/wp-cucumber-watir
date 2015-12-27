require_relative 'container_handler.rb'

# Class holding Selenium interaction
class SeleniumContainer < ContainerHandler
  def run_configuration
    nginx_container_name = @docker_controller.container_name(:nginx)

    { Image:      SELENIUM_IMAGE,
      HostConfig: port_settings_hash([SELENIUM_INTERNAL_PORT]).merge(
        Links: (nginx_domains.map { |e| nginx_container_name + ':' + e })) }
  end

  def start_recording(scenario)
    run_command(
      blc('ffmpeg -y -r 10 -f x11grab -s '\
       "#{BROWSER_WIDTH}x#{BROWSER_HEIGHT}"\
       ' -i :10.0 -vc x264 ' + docker_video_path(scenario)),
      detach: true)
  end

  def video_string(scenario)
    s = ''
    stop_video_recording
    @docker_controller.container(index).copy(docker_video_path(scenario)) do |c|
      s += c
    end
    video_string = ''
    Gem::Package::TarReader
      .new(StringIO.new(s)).seek(docker_video_file(scenario)) do |file|
      video_string += file.read
    end

    video_string
  end

  def discard_video(scenario)
    stop_video_recording
    run_command blc('rm -f ' + docker_video_path(scenario))
  end

  def index
    :selenium
  end

  private

  def stop_video_recording
    run_command blc('pkill ffmpeg'), detach: true
    run_command blc('while pgrep -u root ffmpeg > /dev/null; do sleep 1; done')
  end

  def docker_video_path(scenario)
    '/tmp/' + docker_video_file(scenario)
  end

  def docker_video_file(scenario)
    file_name_base(scenario) + '.mp4'
  end
end
