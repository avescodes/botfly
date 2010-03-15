require 'xmpp4r/muc'

module Botfly
  class MUCClient
    def initialize(room, bot, &block)
      Botfly.logger.info("      MUC: New client created")
      
      @bot,@client = @bot,@bot.client
      @room = room
      @domain = "conference.#{@bot.jid.domain}"  # A sensible default for now
      @resource = @bot.jid.resource
      
      execute(&block) if block_given? # i.e. join(room) do ... end
    end
    
    def as(resource, &block)
      Botfly.logger.info("      MUC: as #{resource}")
      @resource = resource
      execute(&block) if block_given?
    end
    
    def leave_room; raise "Implement Me!"; end
    
    def respond_to(type, params)
      Botfly.logger.info("      MUC: Responding to method in MUC")      
    end
    
  private      

    def connect
      Botfly.logger.info("      MUC: Connecting...")      
      @muc = Jabber::MUC::SimpleMUCClient.new(@client)
      register_for_muc_callbacks
      @muc.join("#{room}@#{domain}/#{resource}")
      Botfly.logger.info("      MUC: Done connecting")
    end

    def execute(&block)
      Botfly.logger.info("      MUC: Block deteceted, executing...")      
      instance_eval(&block)
      register_for_muc_callbacks
      connect
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