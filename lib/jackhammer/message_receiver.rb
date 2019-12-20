module Jackhammer
  # An object meant to be instantiated once but used on each payload received
  # via the #call method
  class MessageReceiver
    attr_reader :handler_class

    def initialize(handler_class)
      @handler_class = handler_class
    end

    def call(message)
      handler = Object.const_get(handler_class)
      if handler.respond_to?(:perform_async)
        handler.perform_async message
      else
        handler.call message
      end
    end
  end
end
