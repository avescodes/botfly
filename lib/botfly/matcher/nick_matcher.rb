require 'botfly/matcher'

module Botfly
  class NickMatcher < Matcher
    def match(params)
      return params[:nick] =~ @condition
    end
  end
end