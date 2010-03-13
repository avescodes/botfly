require 'botfly/matcher'

module Botfly
  class NickMatcher < Matcher
    def match(actual)
      return actual =~ @condition
    end
  end
end