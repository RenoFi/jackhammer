module Jackhammer
  class Queue
    attr_reader :queue, :handler_object

    def initialize(topic:, queue:, handler:, routing_key:)
      @topic = topic
      @queue = queue
      @queue.bind @topic, routing_key: routing_key
      @handler_object = handler
    end

    def subscribe
      queue.subscribe do |delivery_info, properties, content|
        Log.info { [delivery_info.inspect, properties.inspect].join(' || ') }
        Log.debug { content }

        Jackhammer.server_middleware.call(
          handler: handler_object,
          delivery_info: delivery_info,
          properties: properties,
          content: content
        ) do |**args|
          args.fetch(:handler).call args.fetch(:content)
        end
      rescue StandardError => e
        Log.error e
        Jackhammer.configuration.exception_adapter.call e
      end
    end
  end
end
