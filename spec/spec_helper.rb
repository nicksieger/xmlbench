require 'spec'
require 'xmlbench/harness'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/..'

require 'xmlbench/all'
require File.expand_path(File.dirname(__FILE__)) + '/driver_helper'

Spec::Runner.configure do |config|
  config.include(DriverHelper)
  config.extend(DriverExtender)
end
