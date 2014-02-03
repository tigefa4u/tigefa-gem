$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# rubygems
require 'rubygems'

# stdlib
require 'fileutils'
require 'time'
require 'safe_yaml'
require 'English'
require 'pathname'

# 3rd party
require 'liquid'
require 'maruku'
require 'colorator'
require 'toml'

# internal requires
require 'tigefa/core_ext'
require 'tigefa/stevenson'
require 'tigefa/deprecator'
require 'tigefa/configuration'
require 'tigefa/site'
require 'tigefa/convertible'
require 'tigefa/url'
require 'tigefa/layout'
require 'tigefa/page'
require 'tigefa/post'
require 'tigefa/excerpt'
require 'tigefa/draft'
require 'tigefa/filters'
require 'tigefa/static_file'
require 'tigefa/errors'
require 'tigefa/related_posts'
require 'tigefa/cleaner'
require 'tigefa/entry_filter'

# extensions
require 'tigefa/plugin'
require 'tigefa/converter'
require 'tigefa/generator'
require 'tigefa/command'

require_all 'tigefa/commands'
require_all 'tigefa/converters'
require_all 'tigefa/converters/markdown'
require_all 'tigefa/generators'
require_all 'tigefa/tags'

SafeYAML::OPTIONS[:suppress_warnings] = true

module Jekyll
  VERSION = '1.1.1'

  # Public: Generate a Jekyll configuration Hash by merging the default
  # options with anything in _config.yml, and adding the given options on top.
  #
  # override - A Hash of config directives that override any options in both
  #            the defaults and the config file. See Jekyll::Configuration::DEFAULTS for a
  #            list of option names and their defaults.
  #
  # Returns the final configuration Hash.
  def self.configuration(override)
    config = Configuration[Configuration::DEFAULTS]
    override = Configuration[override].stringify_keys
    config = config.read_config_files(config.config_files(override))

    # Merge DEFAULTS < _config.yml < override
    config = config.deep_merge(override).stringify_keys
    set_timezone(config['timezone']) if config['timezone']

    config
  end

  # Static: Set the TZ environment variable to use the timezone specified
  #
  # timezone - the IANA Time Zone
  #
  # Returns nothing
  def self.set_timezone(timezone)
    ENV['TZ'] = timezone
  end

  def self.logger
    @logger ||= Stevenson.new
  end
end
