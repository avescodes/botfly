module Botfly
  module CommonResponderMethods
    def send(nick, message, opts = {})
      Botfly.logger.debug("    RSP: Sending message")
    
      # Fix the nickname if no domain/resource was given by adding your domain
      nick += "@" + @bot.jid.domain if nick !~ /@.*/
      
      opts = { :type => :chat }.merge(opts)
      msg = Jabber::Message.new(nick, message)
      msg.type    = opts[:type]
      msg.subject = opts[:subject]
      @client.send(msg)
    end
    
    def remove(responder_id)
      @bot.remove_responder(responder_id)
    end
  end
end
