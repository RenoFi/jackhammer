module Jackhammer
  class MiddlewareCollection
    def initialize
      @entries = []
    end

    def use(klass, *args, &block)
      @entries << Entry.new(klass: klass, args: args, block: block)
    end

    def call(*args, &block)
      call_chain = @entries.map(&:instantiate) + [block]

      traverse = proc do |*arguments|
        call_chain.shift.call(*arguments, &traverse) unless call_chain.empty?
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
