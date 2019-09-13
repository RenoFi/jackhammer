module Jackhammer
  class Queue
    def initialize(topic:, queue:, handler:, routing:)
      @topic = topic
      @queue = queue
      @queue.bind @topic, routing_key: routing
      @handler_object = handler
    end

    def subscribe
      @queue.subscribe do |delivery_info, properties, content|
        Log.debug [delivery_info.inspect, properties.inspect, content].join(' || ')
        @handler_object.call content
      rescue StandardError => e
        Log.error e
        Jackhammer.configuration.exception_adapter.capture e
      end
    end
  end
end
