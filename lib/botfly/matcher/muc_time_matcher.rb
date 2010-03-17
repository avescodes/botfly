require 'botfly/matcher'

# FIXME: Make time matching much more robust
module Botfly
  class MUCTimeMatcher < Matcher
    def match(params)
      time = params[:time]
      Botfly.logger.debug "MCH: Matching #{@condition.inspect} against #{time}"
      Botfly.logger.debug "RESULT: #{(time =~ @condition).inspect}"
      return time =~ @condition
    end
  end
  
end