require 'forwardable'

#if @matcher_chain.all? {|matcher| matcher.match }
module Botfly
  class Responder
    attr_reader :callback, :type
    
    def initialize(client,bot)
      Botfly.logger.info("Responder#new")
      @matcher_chain = []
      @parent_bot = bot
      @client = client
    end
    
    def method_missing(method,condition=nil,&block)
      Botfly.logger.info("Responder##{method}(#{condition.inspect})")
      if condition  # method is matcher name
        klass = Botfly.const_get(method.to_s.capitalize + "Matcher")
        @matcher_chain << klass.new(condition)
        Botfly.logger.debug("Matcher chain: #{@matcher_chain.inspect}")
        #could rescue NameError, but this way we raise that it doesn't exist
      else          # method is callback name      
        # TODO: Check callback is in acceptable list - MUC subclass can override this list
        @parent_bot.add_responder_of_type(method,self)
      end
      if block_given? && @type
        Botfly.logger.info("Callback recorded")
        @callback = block 
      end
      return self
    end
    
    def callback_with(params)
      @p=params
      Botfly.logger.info("Launching callback")
      instance_eval @callback
    end
    
    def send(nick,msg) #delegate this to the object
      @client.send(Jabber::Message.new(nick,msg))
    end
    
    # TODO: add other @client actions as delegates
      
  end
end