require 'bundler/setup'
require 'active_record'
require 'jackhammer'
require 'jackhammer/cli'
require 'bunny-mock'
require 'json'
require 'byebug'
require 'ostruct'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Jackhammer.connection = BunnyMock.new.start
  end
end

class TestHandlerClass
  def self.call(_msg)
    true
  end
end

class TestAsyncHandlerClass
  def self.call(_msg)
    false
  end

  def self.perform_async(_msg)
    true
  end
end

module Jackhammer
  class TestApp < Server
    configure do |config|
      config.environment = :test
      config.yaml_config = './spec/support/test.yml'
    end
  end

  class TestCLI < CLI
    def server
      OpenStruct.new start: true
    end
  end
end
