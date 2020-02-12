require 'logger'
require 'forwardable'
require 'yaml'
require 'bunny'
require 'jackhammer/version'
require 'jackhammer/exceptions'
require 'jackhammer/log'
require 'jackhammer/configuration'
require 'jackhammer/message_receiver'
require 'jackhammer/queue_name'
require 'jackhammer/queue'
require 'jackhammer/topic'
require 'jackhammer/topic_manager'
require 'jackhammer/server'

module Jackhammer
  class << self
    attr_accessor :configuration
    attr_writer :connection

    def configure
      @configuration = Configuration.instance
      yield @configuration
    end

    def connection
      @connection ||= Bunny.new(
        Jackhammer.configuration.connection_url,
        Jackhammer.configuration.connection_options
      ).start
    end

    def channel
      @channel ||= connection.create_channel
    end

    def topics
      @topics ||= TopicManager.topics
    end

    def publish_options(options = {}, time = Time.now.utc)
      configuration.publish_options.dup.merge(options).tap do |opts|
        opts[:timestamp] = time.to_i
        opts[:app_id] ||= configuration.app_name
        opts[:headers] ||= {}
        opts[:headers][:time] ||= time.iso8601
      end
    end
  end
end
