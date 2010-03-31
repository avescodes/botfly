require 'rubygems'

module Botfly
  class Bot < CommonBlockAcceptor
    attr_reader :client, :roster, :jid, :host    
    def initialize(jid,pass, opts = {})
      super
      Botfly.logger.info("  BOT: Bot#new")
      @password = pass
      @jid = Jabber::JID.new(jid)
      @client = Jabber::Client.new(@jid)
      @main_thread = Thread.current
      if opts[:gtalk]
        @host = "talk.google.com"
      end
    end
    
    def connect
      Botfly.logger.info("  BOT: Connecting to #{@host || @jid}...")
      @client.connect(@host)
      @client.auth(@password)
      Botfly.logger.info("  BOT: Connected")
      register_for_callbacks
      @client.send(Jabber::Presence.new.set_status("Carrier has arrived"))
      @roster = Jabber::Roster::Helper.new(@client)
      #Thread.stop
      self
    end

    def join(room_name,&block)
      return Botfly::MUCClient.new(room_name,self,&block)
    end

    def quit
      @client.close
      @main_thread.continue
    end

    def to_debug_s; "BOT"; end

  private

    def register_for_callbacks
      Botfly.logger.info("  BOT: Registering for callbacks with client")
#     @client.add_update_callback {|presence| respond_to(:update, :presence => presence) }
      @client.add_subscription_request_callback do |item, pres| # requires Roster helper
        Botfly.logger.debug("    CB: Got Message")
        respond_to(:subscription_request, :roster_item => item, :presence => pres)
      end

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
      @responders[callback_type].each {|r| r.callback_with params} if @responders[callback_type]
    end
  end
end
