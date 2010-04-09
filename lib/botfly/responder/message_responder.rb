module Botfly
  class MessageResponder < Responder    
    extend Forwardable
    
    def reply(text)
      Botfly.logger.debug("RSP: MessageResponder#reply called")
      msg = Jabber::Message.new(@from, text)
      msg.type = :chat
      @client.send(msg)
    end
  end
end