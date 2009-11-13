require 'spec'
require 'harness/harness'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/..'

require 'parsers/all'
require File.expand_path(File.dirname(__FILE__)) + '/driver_helper'

Spec::Runner.configure do |config|
  config.include(DriverHelper)
  config.extend(DriverExtender)
end
