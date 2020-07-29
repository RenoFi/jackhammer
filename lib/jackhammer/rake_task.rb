require 'rake'
require 'rake/tasklib'
require 'yaml'
require 'jackhammer/configuration_validator'

module Jackhammer
  class RakeTask < ::Rake::TaskLib
    # Name of test task. (default is :jackhammer)
    attr_accessor :name

    # File path of the configuration file. (default is ./config/jackhammer.yml)
    attr_accessor :path

    # Description of the test task. (default is 'Validate Jackhammer
    # configuration')
    attr_accessor :description

    # Task prerequisites.
    attr_accessor :deps

    # Specifies the environment to inspect. (default is 'production')
    attr_accessor :env

    def initialize
      @name = :jackhammer
      @env = 'production'
      @path = './config/jackhammer.yml'
      @description = 'Validate Jackhammer configuration'
      @deps = []
      yield self if block_given?
      if @name.is_a?(Hash)
        @deps = @name.values.first
        @name = @name.keys.first
      end
      define
    end

    def define
      desc @description
      task @name => Array(deps) do
        validator = ConfigurationValidator.new
        validator.config_yaml = YAML.safe_load(File.read(@path), [], [], true)
        validator.environment = env
        validator.validate
        print_results validator.errors
      end
    end

    private

    def print_results(errors)
      puts "Jackhammer configuration #{path}\n"
      if errors.any?
        puts red("Problems identified: #{errors.size}\n")
        errors.each { |error| puts red(error) }
        exit 1
      else
        puts green('OK')
      end
    end

    def red(text)
      "\e[1;31m#{text}\e[0m"
    end

    def green(text)
      "\e[1;32m#{text}\e[0m"
    end
  end
end
