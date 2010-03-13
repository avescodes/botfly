module Botfly
  class Matcher
    def initialize(condition)
      Botfly.logger.info("Creating Matcher")
      @condition = condition
    end
    def match(params)
      raise "AbstractMethodError: You must implement match in a concrete subclass"
    end
  end
end