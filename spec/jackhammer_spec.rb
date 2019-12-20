RSpec.describe Jackhammer do
  it 'has a version number' do
    expect(Jackhammer::VERSION).not_to be nil
  end

  it 'has singleton access to a Jackhammer::Configuration object' do
    expect(Jackhammer.configuration).to eq(Jackhammer.configuration)
  end

  it 'has singleton access to a Bunny::Channel object' do
    expect(Jackhammer.channel).to eq(Jackhammer.channel)
  end

  it 'has singleton access to a Bunny::Session object' do
    expect(Jackhammer.connection).to be_a BunnyMock::Session
  end

  it 'can set the Bunny connection for test purposes' do
    Jackhammer.connection = 'test'
    expect(Jackhammer.connection).to eq 'test'
  end
end
