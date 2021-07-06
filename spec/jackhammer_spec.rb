RSpec.describe Jackhammer do
  it 'has a version number' do
    expect(Jackhammer::VERSION).not_to be nil
  end

  it 'has singleton access to a Bunny::Session object' do
    expect(described_class.connection).to be_a BunnyMock::Session
  end

  it 'can set the Bunny connection for test purposes' do
    described_class.connection = 'test'
    expect(described_class.connection).to eq 'test'
  end
end
