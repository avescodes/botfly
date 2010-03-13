module Botfly
  class Matcher
    def initialize(condition)
      @condition = condition
    end
    def match(condition)
      raise "AbstractMethodError: You must implement match in a concrete subclass"
    end
  end
end