# frozen_string_literal: true

module Jackhammer
  class TopicManager
    class << self
      def topics
        topics = {}
        Jackhammer.configuration.yaml.each do |topic, topic_config|
          queues = topic_config.delete 'queues'
          topics[topic.to_sym] = Topic.new(name: topic, options: topic_config, queue_config: queues)
        end
        topics
      end
    end
  end
end
