RSpec.describe Jackhammer::TestCLI do
  describe '#run' do
    let(:cli) { described_class.new(require: './lib/jackhammer') }

    subject { cli.run }

    specify { expect(subject).to be }
  end
end
