# Class handling interaction with the commandline
class RunnerCli

  def initialize(wp_site)
    @wp_site = wp_site
  end

  def handle_finish
    answer = ''
    puts('Press q to stop the non persistent containers '\
    'and end the test! Press r to sync files with!')
    while answer != 'q'
      answer = STDIN.getch
      next unless answer == 'r'
      puts 'syncing files'
      @wp_site.sync_wp_plugins
      puts 'files synced'
    end
  rescue Errno::ENOTTY
    puts('not run in a tty! Containers will be left '\
    'running if they were configured to be cached!')
  end
end
