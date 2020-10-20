module Jackhammer
  class Configuration
    attr_accessor(
      :app_name,
      :client_middleware,
      :connection_options,
      :connection_url,
      :environment,
      :exception_adapter,
      :logger,
      :publish_options,
      :server,
      :server_middleware,
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
      @client_middleware = MiddlewareCollection.new
      @server_middleware = MiddlewareCollection.new
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
