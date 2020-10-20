RSpec.describe Jackhammer::MiddlewareCollection do
  subject(:middleware) { described_class.new }

  let(:baz_appender_middleware_class) do
    Class.new do
      def initialize(value)
        @value = value
      end

      def call(foo, opts)
        yield foo, opts.merge(baz: @value)
      end
    end
  end

  let(:show_stopper_middleware_class) do
    Class.new do
      def call(foo, opts)
        # does not yield
      end
    end
  end

  context 'with no entries' do
    it 'calls the passed in block' do
      expect { |block| middleware.call(:foo, bar: 123, &block) }.to yield_with_args(:foo, bar: 123)
    end

    it 'returns the value from the block' do
      expect(middleware.call(:foo, bar: 123) { 'result' }).to eq('result')
    end
  end

  context 'with some middleware specified' do
    before do
      middleware.use baz_appender_middleware_class, 234
    end

    it 'creates a middleware instance and passes args through it' do
      expect { |block| middleware.call(:foo, bar: 123, &block) }.to yield_with_args(:foo, bar: 123, baz: 234)
    end
  end

  context 'with multiple middlewares specified' do
    before do
      middleware.use baz_appender_middleware_class, 1
      middleware.use baz_appender_middleware_class, 2
      middleware.use baz_appender_middleware_class, 3
    end

    it 'executes the middleware in the same order as they were added' do
      expect { |block| middleware.call(:foo, bar: 123, &block) }.to yield_with_args(:foo, bar: 123, baz: 3)
    end

    it 'returns the value from the block' do
      expect(middleware.call(:foo, bar: 123) { 'result' }).to eq('result')
    end
  end

  context 'when a middleware stops the chain execution' do
    before do
      middleware.use baz_appender_middleware_class, 1
      middleware.use show_stopper_middleware_class
      middleware.use baz_appender_middleware_class, 3
    end

    it 'does not execute the block' do
      expect { |block| middleware.call(:foo, bar: 123, &block) }.not_to yield_control
    end
  end

  context 'with singleton/non-class middleware' do
    before do
      middleware.use(proc { |name, opts, &block| block.call(name, opts.merge(hello: 'from proc')) })
    end

    it 'uses the given proc as-is and does not try to call new on it' do
      expect { |block| middleware.call(:foo, bar: 123, &block) }.to yield_with_args(:foo, bar: 123, hello: 'from proc')
    end
  end
end
