require 'botfly/matcher'

module Botfly
  class MUCTextMatcher < Matcher
    def match(params)
      text = params[:text]
      Botfly.logger.debug "      MCH: Matching #{@condition.inspect} against #{text}"
      Botfly.logger.debug "        RESULT: #{(text =~ @condition).inspect}"
      return text =~ @condition
    end
  end
  MUCBodyMatcher = MUCTextMatcher
end