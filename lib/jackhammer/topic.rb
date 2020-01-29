module Jackhammer
  class Topic
    QUEUE_NAME_KEY = 'queue_name'.freeze
    ROUTING_KEY_KEY = 'routing_key'.freeze

    def initialize(name:, options:, queue_config:)
      @topic = Jackhammer.channel.topic name, options
      @queue_config = normalize_queue_config(queue_config)
      @app_name = Jackhammer.configuration.app_name
    end

    def subscribe_queues
      queues.each(&:subscribe)
    end

    # We're expecting the client to specify at least the routing_key in options
    # for each message published.
    def publish(message, options)
      full_options = Jackhammer.configuration.publish_options.dup.merge options
      topic.publish message, full_options
    end

    def queues
      return @queues if @queues

      @queues = queue_config.map do |options|
        handler = MessageReceiver.new(options.delete('handler'))
        routing = fetch_and_delete_key(options, ROUTING_KEY_KEY)
        name = options.delete(QUEUE_NAME_KEY) || name_from_routing(routing)
        queue = Jackhammer.channel.queue(name, options)
        Queue.new(topic: topic, queue: queue, handler: handler, routing: routing)
      end
    end

    private

    attr_reader :topic, :queue_config, :app_name

    # `queue_config` can be either:
    # - an array of options containing `queue_name` key
    # or
    # - a hash containing `queue_name => options` pairs
    def normalize_queue_config(config)
      return config if config.is_a?(Array)

      config.map do |name, options|
        options[QUEUE_NAME_KEY] = name
        options
      end
    end

    def fetch_and_delete_key(options, key)
      options.delete(key) || fail(InvalidConfigError, "#{key} not found in #{options.inspect}")
    end

    def name_from_routing(routing)
      fail(InvalidConfigError, "app_name must be set to determine queue name from routing") unless app_name
      "#{app_name}.#{routing}"
    end
  end
end
