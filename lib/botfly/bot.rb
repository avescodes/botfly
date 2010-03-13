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
      responder = Botfly::Responder.new
      (@responders ||= []) << responder
      return responder
    end
    
  private

    def connect
      @client.connect
      @client.auth(@password)
    end
  
    def join_room(room, as="#{@client.jid.node}", server="#{room}@conference.#{@client.jid.domain}")
      jid = [server,as].join('/')
      muc = Jabber::MUC::SimpleMUCClient.new(@client)

      register_for_muc_callbacks(muc)

      muc.join(Jabber::JID.new(jid))
    end
    
  private

    def register_for_muc_callbacks(client)
      params = {:muc => client}
      client.on_join {|time,nick| respond_to(:join, params.merge!(:time=>time,:nick=>nick))}
      client.on_leave {|time,nick| respond_to(:leave, params.merge!(:time=>time,:nick=>nick))}
      client.on_message {|time,nick,text| respond_to(:message, params.merge!(:time=>time,:nick=>nick,:text=>text))}
      client.on_private_message {|time,nick,text| respond_to(:private_message,    params.merge!(:time=>time,:nick=>nick,:text=>text))}
      client.on_room_message {|time,text| respond_to(:room_message, params.merge!(:time => time, :text => text))}
      client.on_self_leave {|time| respond_to(:self_leave, params.merge!(:time => time)) }
      client.on_subject {|time,nick,subject| respond_to(:subject, params.merge!(:time => time, :nick => nickname, :subject => subject))}
    end
    
    def respond_to(callback, params)
      responders = params[:muc] ? @muc_responders[params[:muc]] : @responders
      responders[params[callback]].each {|r| r.respond_to params}
    end
    
    #as("someone").join("someplace") do #constructs a client context - basically setting the params[:muc] for whatever responder... (maybe an entire object context for the block? - yeah i'll have to)
    #  on(:leave).nick(/Guy/).time("<syntax>") do # construct a responder object,
                                                  # whose block operates in it's context
    #    # operates 
    #  end # the responder is also capapble of telling if it should execute it's block
           # A consequence of the block operating in the responder's context is it allows class & isntance variables to exist and persist
    #end
        
  end
end