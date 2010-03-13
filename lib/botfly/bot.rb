require 'rubygems'

jid = 'mucker@limun.org/botfly'
pass = 'CD.mucker'

module Botfly
  class Bot
    attr_reader :responders
    def initialize(jid,pass)
      Botfly.logger.debug("Bot#new")
      @jid = Jabber::JID.new(jid)
      @password = pass
      @client = Jabber::Client.new(@jid)
    end
  
    def on
      Botfly.logger.debug("Bot#on")
      responder = Botfly::Responder.new(@client, self)
      (@responders ||= []) << responder
      return responder
    end
    
    def connect
      Botfly.logger.debug("Connecting...")
      register_for_xmpp_callbacks
      @client.connect
      @client.auth(@password)
      Botfly.logger.debug("Connected.")
      Thread.stop
    end
      
  private

    def register_for_xmpp_callbacks
      Botfly.logger.debug("Registering for callbacks with @client")
#      @client.add_update_callback {|presence| respond_to(:update, :presence => presence) }
      @client.add_message_callback {|msg| respond_to(:message, :message => message) }
      @client.add_presence_callback {|old_presence,new_presence| respond_to(:presence, :old => old_presence, :new => new_presence) }
      #      @client.add_subscription_request_callback {|item, pres| } # requires Roster helper
    end
    
    def respond_to(callback, params)
      Botfly.logger.debug("Responding to callback of type: #{callback}")
      responders = params[:muc] ? @muc_responders[params[:muc]] : @responders
      responders.reject {|r| r.type != callback}.each {|r| r.callback_with params}
    end
    
#    def register_for_muc_callbacks(client)
#      params = {:muc => client}
##      client.on_join {|time,nick| respond_to(:join, params.merge!(:time=>time,:nick=>nick))}
#      client.on_leave {|time,nick| respond_to(:leave, params.merge!(:time=>time,:nick=>nick))}
#      client.on_message {|time,nick,text| respond_to(:message, params.merge!(:time=>time,:nick=>nick,:text=>text))}
#      client.on_private_message {|time,nick,text| respond_to(:private_message,    params.merge!(:time=>time,:nick=>nick,:text=>text))}
#      client.on_room_message {|time,text| respond_to(:room_message, params.merge!(:time => time, :text => text))}
#      client.on_self_leave {|time| respond_to(:self_leave, params.merge!(:time => time)) }
#      client.on_subject {|time,nick,subject| respond_to(:subject, params.merge!(:time => time, :nick => nickname, :subject => subject))}
#    end    
        
  end
end