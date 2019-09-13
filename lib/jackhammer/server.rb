# frozen_string_literal: true

module Jackhammer
  class Server
    def self.configure
      Jackhammer.configure do |j|
        yield(j)
        j.server = self
      end
    end

    def self.start
      running = true
      Signal.trap('INT') do
        print "\n\nstopping...\n"
        running = false
      end
      Jackhammer.topics.each { |_name, topic| topic.subscribe_queues }
      Log.info 'Topic queues subscribed and listening... Send INT signal to stop.'
      sleep 2 while running
      Jackhammer.connection.close
    end
  end
end
