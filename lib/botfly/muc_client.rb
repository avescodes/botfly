require 'xmpp4r/muc'

module Botfly
  class MUCClient < CommonBlockAcceptor
    attr_reader :bot, :muc
    
    def room; @block_state; end
    
    def initialize(room, bot, &block)
      super
      Botfly.logger.info("MUC: New client created")
      @bot = bot
      @client = @bot.client
      @room = room
      @domain = "conference.#{@bot.jid.domain}"  # A sensible default for now
      @resource = @bot.jid.node
      
      execute(&block) if block_given? # i.e. join(room) do ... end
      return self
    end
    
    def as(resource, &block)
      Botfly.logger.info("MUC: as #{resource}")
      @resource = resource
      execute(&block) if block_given?
      return self
    end
  
    def leave_room; raise "Implement Me!"; end
    

    def respond_to(callback_type, params)
      if (params[:nick] != @resource && Time.now > @connected_at_time + 3)#seconds # Don't run callbacks on the slew of launch messages (at least until I figure out a better way to differentiate them)
        Botfly.logger.info("MUC: Responding to callback of type: #{callback_type} with time of #{params[:time]}")
        @responders[callback_type].each {|r| r.callback_with params} if @responders[callback_type]
      end
    end
    
    def to_debug_s; "MUC"; end
    def class_prefix; "MUC"; end
  private      

    def connect
      Botfly.logger.info("MUC: Connecting...")      
      @muc = Jabber::MUC::SimpleMUCClient.new(@bot.client)
      register_for_callbacks
      @jid = Jabber::JID.new("#{@room}@#{@domain}/#{@resource}")
      @connected_at_time = Time.now
      @muc.join(@jid)
      Botfly.logger.info("MUC: Done connecting")
    end

    def execute(&block)
      Botfly.logger.info("MUC: Block deteceted, executing...")      
      connect
      instance_eval(&block)
    end

    def register_for_callbacks
      Botfly.logger.info("MUC: Registering for MUC callbacks")
      @muc.on_join {|time,nick| respond_to(:join, :time=>time,:nick=>nick)}
      @muc.on_leave {|time,nick| respond_to(:leave, :time=>time,:nick=>nick)}
      @muc.on_message {|time,nick,text| respond_to(:message, :time=>time,:nick=>nick,:text=>text)}
      #@muc.on_private_message {|time,nick,text| respond_to(:private_message,    :time=>time,:nick=>nick,:text=>text)} # Low on the priority to impl. list
      @muc.on_room_message {|time,text| respond_to(:room_message, :time => time, :text => text)}
      @muc.on_self_leave {|time| respond_to(:self_leave, :time => time) }
      @muc.on_subject {|time,nick,subject| respond_to(:subject, :time => time, :nick => nick, :subject => subject)}
    end
  end
end