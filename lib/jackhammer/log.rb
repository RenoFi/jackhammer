# frozen_string_literal: true

module Jackhammer
  class Log
    class << self
      extend Forwardable

      def_delegators :instance, :debug, :info, :warn, :error, :critical

      def instance
        Jackhammer.configuration.logger
      end
    end
  end
end
