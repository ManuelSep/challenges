module Changes
  module Errors
    class RecordInvalid < StandardError; end
    class UnexpectedError < StandardError; end
    class InvalidDateFormat < StandardError; end
  end
end
