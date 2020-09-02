require 'optparse'

module Jackhammer
  class CLI
    attr_reader :logger, :opts

    def initialize(options = {})
      @logger = Logger.new $stderr
      @opts = { require: './config/environment' }.merge(options)
    end

    def parse(argv = ARGV)
      @parser = OptionParser.new do |o|
        o.on "-r", "--require PATH", "Location of application" do |arg|
          opts[:require] = arg
        end
      end
      @parser.banner = "jackhammer [options]"
      @parser.on_tail "-h", "--help", "Show help" do
        logger.info @parser
        exit
      end
      @parser.parse!(argv)
    end

    def run
      require opts[:require]
      Log.info "Booting up Jackhammer v#{VERSION}"
      server.start
    end

    def server
      Jackhammer.configuration.server
    end
  end
end
