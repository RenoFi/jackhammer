# frozen_string_literal: true

module Jackhammer
  class NullExceptionAdapter
    # does nothing with any rescued exceptions
    def capture(_); end
  end
end
