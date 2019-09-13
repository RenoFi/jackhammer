# frozen_string_literal: true

module Jackhammer
  # The API to send messages to a topic with a given attribute
  class Publish
    class << self
      def topics
        @topics ||= {}
      end

      def publish(event, message, options)
        publish_options = Jackhammer.configuration.publish_options # system defaults
        publish_options[:routing_key] = event                   # routing_key
        publish_options = publish_options.merge options         # override any system defaults
        Jackhammer.connection.publish message, publish_options
      end
    end
  end
end
