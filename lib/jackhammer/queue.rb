module Jackhammer
  class Queue
    attr_reader :queue, :handler_object

    def initialize(topic:, queue:, handler:, routing:)
      @topic = topic
      @queue = queue
      @queue.bind @topic, routing_key: routing
      @handler_object = handler
    end

    def subscribe
      queue.subscribe do |delivery_info, properties, content|
        Log.info { [delivery_info.inspect, properties.inspect].join(' || ') }
        Log.debug { content }
        handler_object.call content
      rescue StandardError => e
        Log.error e
        Jackhammer.configuration.exception_adapter.call e
      end
    end
  end
end
