require 'forwardable'
module Botfly
  class MessageResponder < Responder    
    extend Forwardable
    def setup_instance_variables(params)
      Botfly.logger.debug("    RSP: MessageResponder setting up instance variables")
      @message = params[:message]
      @body = @message.body
      @chat_state = @message.chat_state
      @subject = @message.subject
      @type = @message.type
      @from = @message.from
      @to = @message.to
    end
    
    def reply(text)
      Botfly.logger.debug("    RSP: MessageResponder#reply called")
      msg = Jabber::Message.new(@from, text)
      msg.type = :chat
      @client.send(msg)
    end
  end
end