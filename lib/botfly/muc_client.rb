require 'xmpp4r/muc'

module Botfly
  class MUCClient
    extend Forwardable
    attr_accessor :responders
    attr_reader :client, :bot
    
    def_delegator :@block_state, :room
    
    def initialize(room, bot, &block)
      Botfly.logger.info("      MUC: New client created")
      @bot = bot
      @client = @bot.client
      @room = room
      @domain = "conference.#{@bot.jid.domain}"  # A sensible default for now
      @resource = @bot.jid.resource
      
      @block_state = {}
      @responders = {}
      
      execute(&block) if block_given? # i.e. join(room) do ... end
      return self
    end
    
    def as(resource, &block)
      Botfly.logger.info("      MUC: as #{resource}")
      @resource = resource
      execute(&block) if block_given?
      return self
    end
    
    class OnRecognizer
      def initialize(obj); @obj = obj; end

      def method_missing(type,&block)
        Botfly.logger.info("      MUC: MUCClient#on")
        klass = Botfly.const_get("MUC" + type.to_s.capitalize + "Responder")
        (@obj.responders[type] ||= []) << responder = klass.new(@obj.client, @obj, &block)
        Botfly.logger.info("      MUC: MUC#{type.to_s.capitalize}Responder added to responder chain")
        return responder
      end
    end
    
    def on
      return OnRecognizer.new(self)
    end
    
    def leave_room; raise "Implement Me!"; end
    
    def respond_to(type, params)
      Botfly.logger.info("      MUC: Responding to method in MUC")      
    end
    
    def [](key)
      @block_state[key]
    end
    
    def []=(key, set_to)
      @block_state[key] = set_to
    end
  private      

    def connect
      Botfly.logger.info("      MUC: Connecting...")      
      @muc = Jabber::MUC::SimpleMUCClient.new(@bot.client)
      register_for_muc_callbacks
      @jid = Jabber::JID.new("#{@room}@#{@domain}/#{@resource}")
      @muc.join(@jid)
      Botfly.logger.info("      MUC: Done connecting")
    end

    def execute(&block)
      Botfly.logger.info("      MUC: Block deteceted, executing...")      
      connect
      instance_eval(&block)
    end

    def register_for_muc_callbacks
      Botfly.logger.info("      MUC: Registering for MUC callbacks")
      params = {:muc => @muc }
      @muc.on_join {|time,nick| respond_to(:join, params.merge!(:time=>time,:nick=>nick))}
      @muc.on_leave {|time,nick| respond_to(:leave, params.merge!(:time=>time,:nick=>nick))}
      @muc.on_message {|time,nick,text| respond_to(:message, params.merge!(:time=>time,:nick=>nick,:text=>text))}
      #@muc.on_private_message {|time,nick,text| respond_to(:private_message,    params.merge!(:time=>time,:nick=>nick,:text=>text))} # Low on the priority to impl. list
      @muc.on_room_message {|time,text| respond_to(:room_message, params.merge!(:time => time, :text => text))}
      @muc.on_self_leave {|time| respond_to(:self_leave, params.merge!(:time => time)) }
      @muc.on_subject {|time,nick,subject| respond_to(:subject, params.merge!(:time => time, :nick => nickname, :subject => subject))}
     end
  
    def method_missing?; end
  end
end