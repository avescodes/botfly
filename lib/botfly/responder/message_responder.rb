module Botfly
  class MessageResponder < Responder
    def setup_instance_variables(params)
      Botfly.logger.debug("    RSP: MessageResponder setting up instance variables")
    end
    
    def reply(msg)
      msg = Jabber::Message.new(params[:message].from, msg)
      msg.type = :chat
      @client.send(msg)
    end
end