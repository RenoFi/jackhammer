require 'jackhammer/configuration_validator'

TestChicagoWeatherHandler = Class.new

RSpec.describe Jackhammer::ConfigurationValidator do
  describe '#errors' do
    subject { validator.errors }

    let(:validator) { described_class.new }

    specify { expect(subject).to eq [] }

    context 'with valid YAML' do
      before do
        validator.environment = 'production'
        validator.config_yaml = YAML.safe_load <<~YAML
          ---
          production:
            MyTopic:
              queues:
                - routing_key: 'weather.chicago'
                  handler: TestChicagoWeatherHandler
        YAML
        validator.validate
      end

      specify { expect(subject).to eq [] }
    end

    context 'with wrong environment' do
      before do
        validator.environment = 'test'
        validator.config_yaml = YAML.safe_load <<~YAML
          ---
          production:
            MyTopic:
              queues:
                - routing_key: 'weather.chicago'
                  handler: TestChicagoWeatherHandler
        YAML
        validator.validate
      end

      specify { expect(subject).to match_array ["Environment 'test' is not defined"] }
    end

    context 'with missing queues' do
      before do
        validator.environment = 'production'
        validator.config_yaml = YAML.safe_load <<~YAML
          ---
          production:
            MyTopic:
              - routing_key: 'weather.chicago'
                handler: TestChicagoWeatherHandler
        YAML
        validator.validate
      end

      specify { expect(subject).to match_array ["Topic 'MyTopic' does not define any queues"] }
    end

    context 'with an unknown constant' do
      before do
        validator.environment = 'production'
        validator.config_yaml = YAML.safe_load <<~YAML
          ---
          production:
            MyTopic:
              queues:
                - routing_key: 'weather.chicago'
                  handler: TestHandlerAbC123
        YAML
        validator.validate
      end

      specify { expect(subject).to match_array ['Uninitialized constant TestHandlerAbC123'] }
    end
  end
end
