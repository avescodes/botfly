require 'botfly/matcher'

module Botfly
  class NickMatcher < Matcher
    def match(params)
      Botfly.logger.warn "Matching #{@condition.inspect} against #{params[:nick]}"
      return params[:nick] =~ @condition
    end
  end
end