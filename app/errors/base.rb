module Errors
  class Base < StandardError
    attr_reader :http_status
  end
end
