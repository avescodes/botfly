require 'forwardable'

#if @matcher_chain.all? {|matcher| matcher.match }
module Botfly
  class Responder
    attr_reader :callback, :type
    
    def initialize(client,bot)
      Botfly.logger.debug("Responder#new")
      @matcher_chain = []
      @parent_bot = bot
      @client = client
    end
    
    def method_missing(method,condition=nil,&block)
      Botfly.logger.debug("Responder##{method}(#{condition.inspect})")
      if condition  # method is matcher name
        klass = Botfly.const_get(method.capitalize + "Matcher")
        @matcher_chain << klass.new(condition)
        #could rescue NameError, but this way we raise that it doesn't exist
      else          # method is callback name      
        # TODO: Check callback is in acceptable list - MUC subclass can override this list
        @type = method.to_sym
      end
      if block_given? && @type
        Botfly.logger.debug("Callback recorded")
        @callback = block 
      end
      return self
    end
    
    def callback_with(params)
      @p=params
      Botfly.logger.debug("Launching callback")
      instance_eval @callback
    end
    
    def say(msg) #delegate this to the object
      @client.say(msg)
    end
    
    # TODO: add other @client actions as delegates
      
  end
end