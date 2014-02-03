module Tigefa
  class Command
    def self.globs(source, destination)
      Dir.chdir(source) do
        dirs = Dir['*'].select { |x| File.directory?(x) }
        dirs -= [destination, File.expand_path(destination), File.basename(destination)]
        dirs = dirs.map { |x| "#{x}/**/*" }
        dirs += ['*']
      end
    end

    # Static: Run Site#process and catch errors
    #
    # site - the Tigefa::Site object
    #
    # Returns nothing
    def self.process_site(site)
      site.process
    rescue Tigefa::FatalException => e
      puts
      Tigefa.logger.error "ERROR:", "YOUR SITE COULD NOT BE BUILT:"
      Tigefa.logger.error "", "------------------------------------"
      Tigefa.logger.error "", e.message
      exit(1)
    end
  end
end
