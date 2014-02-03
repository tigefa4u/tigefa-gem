module Tigefa
  module Commands
    class Build < Command
      def self.process(options)
        site = Tigefa::Site.new(options)

        self.build(site, options)
        self.watch(site, options) if options['watch']
      end

      # Private: Build the site from source into destination.
      #
      # site - A Tigefa::Site instance
      # options - A Hash of options passed to the command
      #
      # Returns nothing.
      def self.build(site, options)
        source = options['source']
        destination = options['destination']
        Tigefa.logger.info "Source:", source
        Tigefa.logger.info "Destination:", destination
        print Tigefa.logger.formatted_topic "Generating..."
        self.process_site(site)
        puts "done."
      end

      # Private: Watch for file changes and rebuild the site.
      #
      # site - A Tigefa::Site instance
      # options - A Hash of options passed to the command
      #
      # Returns nothing.
      def self.watch(site, options)
        require 'listen'

        source = options['source']
        destination = options['destination']

        begin
          dest = Pathname.new(destination).relative_path_from(Pathname.new(source)).to_s
          ignored = Regexp.new(Regexp.escape(dest))
        rescue ArgumentError
          # Destination is outside the source, no need to ignore it.
          ignored = nil
        end

        Tigefa.logger.info "Auto-regeneration:", "enabled"

        listener = Listen::Listener.new(source, :ignore => ignored) do |modified, added, removed|
          t = Time.now.strftime("%Y-%m-%d %H:%M:%S")
          n = modified.length + added.length + removed.length
          print Tigefa.logger.formatted_topic("Regenerating:") + "#{n} files at #{t} "
          self.process_site(site)
          puts  "...done."
        end
        listener.start

        unless options['serving']
          trap("INT") do
            listener.stop
            puts "     Halting auto-regeneration."
            exit 0
          end

          loop { sleep 1000 }
        end
      end
    end
  end
end
