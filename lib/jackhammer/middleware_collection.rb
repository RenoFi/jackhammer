module Jackhammer
  class MiddlewareCollection
    def initialize
      @entries = []
    end

    def use(klass, *args, **kwargs, &block)
      @entries << Entry.new(klass: klass, args: args, kwargs: kwargs, block: block)
    end

    def call(*args, **kwargs, &block)
      call_chain = @entries.map(&:instantiate) + [block]

      traverse = proc do |*procargs, **prockwargs|
        call_chain.shift.call(*procargs, **prockwargs, &traverse) unless call_chain.empty?
      end

      traverse.call(*args, **kwargs)
    end

    Entry = Struct.new(:klass, :args, :kwargs, :block, keyword_init: true) do
      def instantiate
        return klass unless klass.respond_to?(:new)

        klass.new(*args, **kwargs, &block)
      end
    end
  end
end
