require 'rubygems'

module Botfly
  class Bot < CommonBlockAcceptor
    attr_reader :jid
    
    def initialize(jid,pass)
      Botfly.logger.info("  BOT: Bot#new")
      @password = pass
      @jid = Jabber::JID.new(jid)
      @client = Jabber::Client.new(@jid)
      @responders = {}
      @main_thread = Thread.current
      @block_state = {}
    end
    
    def connect
      Botfly.logger.info("  BOT: Connecting to #{@jid}...")
      @client.connect
      @client.auth(@password)
      Botfly.logger.info("  BOT: Connected")
      register_for_callbacks
      @client.send(Jabber::Presence.new.set_status("Carrier has arrived"))
      #Thread.stop
    end
    
    def on
      return OnRecognizer.new(self)
    end
    
    def join(room_name,&block)
      return Botfly::MUCClient.new(room_name,self,&block)
    end
      
    def quit
      @client.close
      @main_thread.continue
    end
    
    def remove_responder(id_to_remove)
      Botfly.logger.info("  BOT: Removing responder #{id_to_remove}")
      @responders.each { |pair| key,chain = pair; chain.reject! {|r| r.id == id_to_remove } }
    end

    def to_debug_s
      "BOT"
    end
    
  private

    def register_for_callbacks
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
