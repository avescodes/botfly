require 'rubygems'

module Botfly
  class Bot
    attr_reader :responders, :client, :jid
    
    def initialize(jid,pass)
      Botfly.logger.info("  BOT: Bot#new")
      @password = pass
      @jid = Jabber::JID.new(jid)
      @client = Jabber::Client.new(@jid)
      @responders = {}
      @main_thread = Thread.current
    end
    
    def connect
      Botfly.logger.info("  BOT: Connecting to #{@jid}...")
      @client.connect
      @client.auth(@password)
      Botfly.logger.info("  BOT: Connected")
      register_for_xmpp_callbacks
      @client.send(Jabber::Presence.new.set_status("Carrier has arrived"))
      #Thread.stop
    end
    
    def on(type, &block)
      Botfly.logger.info("  BOT: Bot#on")
      klass = Botfly.const_get(type.to_s.capitalize + "Responder")
      (@responders[type] ||= []) << responder = klass.new(@client, self, &block)
      Botfly.logger.info("  BOT: #{type.to_s.capitalize}Responder added to responder chain")
      return responder
    end
    
    def join(room_name,&block)
      return MUCClient.new(room_name,self,&block)
    end
      
    def quit
      @client.close
      @main_thread.continue
    end
      
  private

    def register_for_xmpp_callbacks
      Botfly.logger.info("  BOT: Registering for callbacks with client")
#     @client.add_update_callback {|presence| respond_to(:update, :presence => presence) }
#     @client.add_subscription_request_callback {|item, pres| } # requires Roster helper
      @client.add_message_callback do |message| 
        Botfly.logger.debug("    CB: Got Message") 
        respond_to(:message, :message => message)
      end
      @client.add_presence_callback do |new_presence,old_presence| 
        Botfly.logger.debug("    CB: Got Presence")
        respond_to(:presence, :old => old_presence, :new => new_presence)
      end

    end
    
    def respond_to(callback_type, params)
      Botfly.logger.info("  BOT: Responding to callback of type: #{callback_type}")
      responders = params[:muc] ? @muc_responders[params[:muc]] : @responders
      responders[callback_type].each {|r| r.callback_with params} if responders[callback_type]
    end
        
  end
end