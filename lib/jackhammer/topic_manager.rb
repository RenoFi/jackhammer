# frozen_string_literal: true

module Jackhammer
  class TopicManager
    class << self
      def topics
        result = {}
        Jackhammer.configuration.yaml.each do |topic, topic_config|
          fail(InvalidConfigError, "Topic config is invalid") unless topic_config.is_a?(Hash)
          queues = topic_config.delete 'queues'
          result[topic.to_sym] = Topic.new(name: topic, options: topic_config, queue_config: queues)
        end
        result
      end
    end
  end
end
