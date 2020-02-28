RSpec.describe Jackhammer::MessageReceiver do
  describe '#call' do
    subject { receiver.call message }

    let(:receiver) { described_class.new(handler_class) }
    let(:message) { { a: 1 }.to_json }

    context 'when handler_class is not a constant' do
      let(:handler_class) { 'NotAConstant' }

      specify { expect { subject }.to raise_exception(NameError, 'uninitialized constant NotAConstant') }
    end

    context 'when handler_class defines .call' do
      let(:handler_class) { 'TestHandlerClass' }

      specify { expect(subject).to eq(true) }
    end

    context 'when handler_class also defines .perform_async' do
      let(:handler_class) { 'TestAsyncHandlerClass' }

      specify { expect(subject).to eq(true) }
    end
  end
end
