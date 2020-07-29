module Jackhammer
  class ConfigurationValidator
    attr_accessor :config_yaml, :environment, :errors

    def initialize
      @errors = []
    end

    def validate
      validate_environment_defined
      return if errors.any?
      validate_topic_exchange_defined
      return if errors.any?
      validate_queues_defined
      return if errors.any?
      validate_handlers_defined
    end

    def validate_environment_defined
      return if config_yaml[environment]

      add_error("Environment '#{environment}' is not defined")
    end

    def validate_topic_exchange_defined
      return if config_yaml[environment].keys.any?

      add_error("Environment '#{environment}' does not define a topic exchange")
    end

    def validate_queues_defined
      topics = config_yaml[environment].keys
      topics.each do |topic|
        begin
          next if config_yaml[environment][topic]['queues']
        rescue StandardError
          false
        end

        add_error("Topic '#{topic}' does not define any queues")
      end
    end

    def validate_handlers_defined
      config_yaml[environment].each do |exchange_name, exchange_config|
        exchange_config['queues'].each do |qconfig|
          Object.const_get(qconfig['handler'])
        rescue NameError
          add_error("Uninitialized constant #{qconfig['handler']}")
        end
      end
    end

    private

    def add_error(str)
      @errors << str
    end
  end
end
