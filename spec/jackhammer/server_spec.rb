RSpec.describe Jackhammer::Server do
  describe '.configure' do
    context 'when class TestApp < Jackhammer::Server' do
      it 'sets Jackhammer.configuration.server to TestApp' do
        class TestApp < Jackhammer::Server
          configure do |jack|
          end
        end
        expect(Jackhammer.configuration.server).to eq TestApp
      end
    end
  end
end
