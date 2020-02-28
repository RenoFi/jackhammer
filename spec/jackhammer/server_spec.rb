RSpec.describe Jackhammer::Server do
  describe '.configure' do
    context 'when class TestApp < Jackhammer::Server' do
      let(:test_app) do
        Class.new(described_class)
      end

      before do
        test_app.configure do |jack|
          # do nothing
        end
      end

      it 'sets Jackhammer.configuration.server to test_app' do
        expect(Jackhammer.configuration.server).to eq test_app
      end
    end
  end
end
