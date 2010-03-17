require 'botfly/matcher'

# Msg: body, chat_state, subject, type (:chat, :error, :groupchat, :headline, :normal)
module Botfly
  class NickMatcher < Matcher
    def match(params)
      msg = params[:message]
      Botfly.logger.debug "MCH: Matching #{@condition.inspect} against #{msg.from.inspect}"
      Botfly.logger.debug "RESULT: #{(msg.from.node =~ @condition).inspect}"
      return msg.from.node =~ @condition
    end
  end
  FromMatcher = NickMatcher
end