RSpec.describe Jackhammer::TestCLI do
  describe '#run' do
    subject { cli.run }

    let(:cli) { described_class.new(require: './lib/jackhammer') }

    specify { expect(subject).to eq(true) }
  end
end
