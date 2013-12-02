if RUBY_VERSION > '1.9'
  require 'simplecov'
  require 'simplecov-gem-adapter'
  SimpleCov.start('gem')

  require 'coveralls'
  Coveralls.wear_merged!
end
