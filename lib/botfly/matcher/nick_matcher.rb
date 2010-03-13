require 'botfly/matcher'

module Botfly
  class NickMatcher < Matcher
    def match(params)
      Botfly.logger.debug "MCH: Matching #{@condition.inspect} against #{params[:nick]}"
      return params[:nick] =~ @condition
    end
  end
end