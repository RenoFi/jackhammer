# frozen_string_literal: true

module Jackhammer
  class Topic
    def initialize(name:, options:, queue_config:)
      @topic = Jackhammer.channel.topic name, options
      @queue_config = queue_config
    end

    def subscribe_queues
      queues.each(&:subscribe)
    end

    # We're expecting the client to specify at least the routing_key in options
    # for each message published.
    def publish(message, options)
      full_options = Jackhammer.configuration.publish_options.dup.merge options
      @topic.publish message, full_options
    end

    def queues
      return @queues if @queues

      @queues = @queue_config.map do |name, options|
        handler = MessageReceiver.new(options.delete('handler'))
        routing = options.delete 'routing_key'
        queue = Jackhammer.channel.queue name, options
        Queue.new topic: @topic, queue: queue, handler: handler, routing: routing
      end
    end
  end
end
