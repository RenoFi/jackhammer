RSpec.describe Jackhammer::QueueName do
  before do
    Jackhammer.configuration.app_name = app_name
  end

  describe '.from_routing_key' do
    subject(:queue_name) { described_class.from_routing_key(routing_key) }

    let(:routing_key) { 'food.burgers.#' }

    context 'when app_name is set' do
      let(:app_name) { 'test-app' }

      it do
        expect(queue_name).to eq('test_app_food_burgers_q')
      end
    end

    context 'when app_name is not set' do
      let(:app_name) { '' }

      it do
        expect { queue_name }.to raise_error(InvalidConfigError)
      end
    end
  end
end
