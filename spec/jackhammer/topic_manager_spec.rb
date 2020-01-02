RSpec.describe Jackhammer::TopicManager do
  describe '.topics' do
    subject { described_class.topics }

    before do
      allow(Jackhammer).to receive(:configuration) { config_double }
    end

    context 'when configuration yaml contains empty config' do
      let(:config_double) { double(yaml: {}) }

      specify { expect(subject).to eq({}) }
    end

    context 'when configuration yaml defines queues as hash' do
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
        specify do
          expect(subject[:my_topic]).to be_a Jackhammer::Topic
          expect(subject[:my_topic].queues).not_to be_empty
          expect(subject[:my_topic].queues.first.queue.name).to eq('first_queue')
        end
      end
    end

    context 'when configuration yaml defines queues as array' do
      let(:yaml) do
        {
          'my_topic' => {
            'arguments' => true,
            'auto_delete' => true,
            'durable' => true,
            'queues' => [
              'queue_name' => 'first_queue',
              'durable' => true,
              'auto_delete' => false,
              'handler' => 'FakeClient',
              'routing_key' => 'first_queue.event'
            ]
          }
        }
      end
      let(:config_double) { double(yaml: yaml) }

      specify { expect(subject).to be_a Hash }

      describe '.topics[:my_topic]' do
        specify do
          expect(subject[:my_topic]).to be_a Jackhammer::Topic
          expect(subject[:my_topic].queues).not_to be_empty
          expect(subject[:my_topic].queues.first.queue.name).to eq('first_queue')
        end
      end
    end

    context 'when configuration yaml defines contains invalid queue config without queue_name' do
      let(:yaml) do
        {
          'my_topic' => {
            'arguments' => true,
            'auto_delete' => true,
            'durable' => true,
            'queues' => [
              # no queue_name
              'durable' => true,
              'auto_delete' => false,
              'handler' => 'FakeClient',
              'routing_key' => 'first_queue.event'
            ]
          }
        }
      end
      let(:config_double) { double(yaml: yaml) }

      specify { expect(subject).to be_a Hash }

      describe '.topics[:my_topic]' do
        specify { expect { subject[:my_topic].queues }.to raise_error(InvalidConfigError) }
      end
    end

    context 'when configuration yaml defines contains invalid queue config without routing_key' do
      let(:yaml) do
        {
          'my_topic' => {
            'arguments' => true,
            'auto_delete' => true,
            'durable' => true,
            'queues' => [
              'queue_name' => 'first_queue',
              'durable' => true,
              'auto_delete' => false,
              'handler' => 'FakeClient',
              # no routing_key
            ]
          }
        }
      end
      let(:config_double) { double(yaml: yaml) }

      specify { expect(subject).to be_a Hash }

      describe '.topics[:my_topic]' do
        specify { expect { subject[:my_topic].queues }.to raise_error(InvalidConfigError) }
      end
    end
  end
end
