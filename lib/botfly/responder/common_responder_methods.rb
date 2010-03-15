module Botfly
  module CommonResponderMethods
    def send(nick, message, opts = {})
      opts = { :type => :chat }.merge(opts)
      msg = Jabber::Message.new(nick, message)
      msg.type    = opts[:type]
      msg.subject = opts[:subject]
    end
  end
end
