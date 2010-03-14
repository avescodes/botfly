require 'botfly/matcher'

# Msg: body, chat_state, subject, type (:chat, :error, :groupchat, :headline, :normal)
module Botfly
  class SubjectMatcher < Matcher
    def match(params)
      msg = params[:message]
      Botfly.logger.debug "      MCH: Matching #{@condition.inspect} against #{msg.subject.inspect}"
      Botfly.logger.debug "        RESULT: #{(msg.subject =~ @condition).inspect}"
      return msg.subject =~ @condition
    end
  end
end