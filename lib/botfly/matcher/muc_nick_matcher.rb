require 'botfly/matcher'

module Botfly
  class MUCNickMatcher < Matcher
    def match(params)
      nick = message[:nick]
      Botfly.logger.debug "      MCH: Matching #{@condition.inspect} against #{nick}"
      Botfly.logger.debug "        RESULT: #{(nick =~ @condition).inspect}"
      return nick =~ @condition
    end
  end
  MUCFromMatcher = MUCNickMatcher
end