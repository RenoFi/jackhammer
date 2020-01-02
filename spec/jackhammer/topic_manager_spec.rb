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

    context 'when configuration yaml defines queues' do
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
                'routing_key' => 'first_queue.event_a'
              },
              'second_queue' => {
                'durable' => false,
                'auto_delete' => false,
                'handler' => 'FakeClient',
                'routing_key' => 'first_queue.event_b'
              }
            }
          }
        }
      end
      let(:config_double) { double(yaml: yaml) }

      specify { expect(subject).to be_a Hash }
      specify { expect(subject.keys).to eq [:my_topic] }

      describe '[:my_topic]' do
        specify { expect(subject[:my_topic]).to be_a Jackhammer::Topic }

        describe '#queues#first' do
          specify { expect(subject[:my_topic].queues.first).to be_a Jackhammer::Queue }
        end

        describe '#queues#size' do
          specify { expect(subject[:my_topic].queues.size).to eq 2 }
        end
      end
    end

    context 'when configuration yaml contains invalid queue config' do
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
                # no routing_key
              },
              'second_queue' => {
                'durable' => false,
                'auto_delete' => false,
                'handler' => 'FakeClient',
                'routing_key' => 'first_queue.event_b'
              }
            }
          }
        }
      end
      let(:config_double) { double(yaml: yaml) }

      specify { expect(subject).to be_a Hash }
      specify { expect(subject.keys).to eq [:my_topic] }

      describe '[:my_topic]' do
        specify { expect(subject[:my_topic]).to be_a Jackhammer::Topic }
        specify { expect { subject[:my_topic].queues }.to raise_error(InvalidConfigError) }
      end
    end
  end
end
