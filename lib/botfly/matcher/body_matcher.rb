require 'botfly/matcher'

# Msg: body, chat_state, subject, type (:chat, :error, :groupchat, :headline, :normal)
module Botfly
  class BodyMatcher < Matcher
    def match(params)
      msg = params[:message]
      Botfly.logger.debug "      MCH: Matching #{@condition.inspect} against #{msg.body.inspect}"Botfly.logger.debug "        RESULT: #{(msg.body =~ @condition).inspect}"
      return msg.body =~ @condition
    end
  end
end