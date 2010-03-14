require 'forwardable'
module Botfly
  class MessageResponder < Responder    
    extend Forwardable
    def_delegators :@message, :body, :chat_state, :subject, :subject, :type, :from, :to
    def setup_instance_variables(params)
      Botfly.logger.debug("    RSP: MessageResponder setting up instance variables")
      @message = params[:message]
    end
    
    def reply(msg)
      Botfly.logger.debug("    RSP: MessageResponder#reply called")
      msg = Jabber::Message.new(from, msg)
      msg.type = :chat
      @client.send(msg)
    end
  end
end