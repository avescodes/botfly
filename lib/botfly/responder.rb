require 'forwardable'

module Botfly
  class Responder
    attr_reader :callback, :callback_type
    
    def initialize(client,bot)
      Botfly.logger.info("    RSP: Responder#new")
      @matcher_chain = []
      @parent_bot = bot
      @client = client
    end
    
    def method_missing(method,condition=nil,&block)
      Botfly.logger.info("    RSP: Responder##{method}(#{condition.inspect})")
      
      if condition  # method is matcher name
        add_matcher(method,condition)
      else          # method is callback name      
        register_with_bot(method)
      end
      
      if block_given? && @type
        Botfly.logger.info("    RSP: Callback recorded")
        @callback = block 
      end
      
      return self
    end
    
    def callback_with(params)
      @p=params
      Botfly.logger.debug("    RSP: Launching callback with params: #{params.inspect}")
      if @matcher_chain.all? {|matcher| matcher.match(params) }
        self.instance_eval @callback
      end
    end
    
    def send(nick,msg) #delegate this to the object
      Botfly.logger.debug("    RSP: Sending message to #{nick}: #{msg}")
      m=Jabber::Message.new(nick,msg)
      m.type = :chat
      @client.send(m)
    end
    # TODO: add other @client actions as delegates    

  private
    def add_matcher(method, condition)
      klass = Botfly.const_get(method.to_s.capitalize + "Matcher")
      @matcher_chain << klass.new(condition)
      Botfly.logger.debug("    RSP: Adding to matcher chain: #{@matcher_chain.inspect}")
    end
    
    def register_with_bot(callback_type)
      # TODO: Check callback is in acceptable list - MUC subclass can override this list
      Botfly.logger.debug("    RSP: Registering :#{callback_type} responder with bot")
      if [:message, :presence].include? callback_type
        @parent_bot.add_responder_of_type(callback_type,self)
      else
        raise NoMethodError.new("undefined method '#{m}' for #{inspect}:#{self.class}")
      end
    end
  end
end