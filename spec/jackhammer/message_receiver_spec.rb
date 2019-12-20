RSpec.describe Jackhammer::MessageReceiver do
  describe '#call' do
    let(:receiver) { described_class.new(handler_class) }
    let(:message) { { a: 1 }.to_json }

    subject { receiver.call message }

    context 'when handler_class is not a constant' do
      let(:handler_class) { 'NotAConstant' }

      specify { expect { subject }.to raise_exception(NameError, 'uninitialized constant NotAConstant') }
    end

    context 'when handler_class defines .call' do
      let(:handler_class) { 'TestHandlerClass' }

      specify { expect(subject).to be }
    end

    context 'when handler_class also defines .perform_async' do
      let(:handler_class) { 'TestAsyncHandlerClass' }

      specify { expect(subject).to be }
    end
  end
end
