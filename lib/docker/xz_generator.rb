require 'rubygems'
require 'rubygems/package'
require 'xz'

# Module for compressing data to be sent to Docker
module XZGen
  def xz(paths)
    tar_string = tar(paths).string
    tar_string = XZ.compress(tar_string, 9) if @config_handler.compress_streams?

    tar_string
  end

  private

  def tar(paths)
    tarfile = StringIO.new('')
    Gem::Package::TarWriter.new(tarfile) do |tar|
      paths.each do |root, path|
        Dir[File.join(path, '**/{,.}*')].each do |file|
          next if file.match(%r{(\.git)|(\.svn)|(/tests/)})
          mode          = File.stat(file).mode
          relative_file = (root.reverse.chomp('/').reverse + '/' +
                          file.sub(%r{^#{Regexp.escape path}/?}, ''))
                          .reverse.chomp('/').reverse

          if File.directory?(file)
            tar.mkdir relative_file, mode
          else
            tar.add_file relative_file, mode do |tf|
              File.open(file, 'rb') { |f| tf.write f.read }
            end
          end
        end
      end
    end

    tarfile.rewind
    tarfile
  end
end
