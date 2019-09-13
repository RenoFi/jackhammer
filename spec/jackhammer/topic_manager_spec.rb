# frozen_string_literal: true

RSpec.describe Jackhammer::TopicManager do
  describe '.topics' do
    subject { described_class.topics }

    before do
      allow(Jackhammer).to receive(:configuration) { config_double }
    end

    context 'when Jackhammer.configuration.subscribe_yaml returns empty config' do
      let(:config_double) { double(yaml: {}) }

      specify { expect(subject).to eq({}) }
    end

    context 'when Jackhammer.configuration.subscribe_yaml defines queues' do
      let(:yaml) do
        {
          'my_topic' => {
            'arguments' => true,
            'auto_delete' => true,
            'durable' => true,
            'queues' => {
              'first_queue' => {
                'durable' => true,
                'auto_delete' => false,
                'handler' => 'FakeClient',
                'routing_key' => 'first_queue.event'
              }
            }
          }
        }
      end
      let(:config_double) { double(yaml: yaml) }

      specify { expect(subject).to be_a Hash }

      describe '.topics[:my_topic]' do
        specify { expect(subject[:my_topic]).to be_a Jackhammer::Topic }
      end
    end
  end
end
