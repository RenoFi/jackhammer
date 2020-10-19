module Jackhammer
  class MiddlewareCollection
    def initialize
      @entries = []
    end

    def use(klass, *args, &block)
      @entries << Entry.new(klass: klass, args: args, block: block)
    end

    def call(*args)
      return yield *args if @entries.empty?

      middlewares = @entries.map(&:instantiate)
      traverse = proc do |*arguments|
        if middlewares.empty?
          yield *arguments
        else
          middleware = middlewares.shift
          middleware.call(*arguments, &traverse)
        end
      end

      traverse.call(*args)
    end

    Entry = Struct.new(:klass, :args, :block, keyword_init: true) do
      def instantiate
        return klass unless klass.respond_to?(:new)

        klass.new(*args, &block)
      end
    end
  end
end