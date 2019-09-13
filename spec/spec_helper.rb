# frozen_string_literal: true

require 'bundler/setup'
require 'jackhammer'
require 'jackhammer/cli'
require 'bunny-mock'
require 'json'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
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
