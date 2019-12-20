# frozen_string_literal: true

module Jackhammer
  class Configuration
    attr_accessor(
      :connection_options,
      :connection_url,
      :environment,
      :exception_adapter,
      :logger,
      :publish_options,
      :server,
      :yaml_config
    )

    def initialize
      @connection_options = {}
      @connection_url = ENV['RABBITMQ_URL']
      @environment = ENV['RACK_ENV'] || :development
      @exception_adapter = proc { |e| fail e }
      @logger = Logger.new IO::NULL
      @publish_options = { mandatory: true, persistent: true }
      @yaml_config = './config/jackhammer.yml'
    end

    def self.instance
      @instance ||= new
    end

    def yaml
      environment = Jackhammer.configuration.environment.to_s
      YAML.load_file(Jackhammer.configuration.yaml_config)[environment]
    end
  end
end
