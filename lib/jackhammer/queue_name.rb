module Jackhammer
  class QueueName
    def self.app_name
      Jackhammer.configuration.app_name
    end

    def self.from_routing_key(routing_key)
      fail(InvalidConfigError, "app_name must be set to determine queue_name from routing_key") if app_name.to_s.empty?

      "#{app_name}_#{routing_key}_q".gsub(/[^\w]+/, '_').gsub(/[_]+/, '_')
    end
  end
end
