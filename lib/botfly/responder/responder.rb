module Botfly
  class Responder
    attr_reader :callback, :callback_type
    
    def initialize(client,bot)
      Botfly.logger.info("    RSP: Responder#new")
      @matcher_chain = []
      @bot = bot
      @client = client
    end
    
    def method_missing(method,condition=nil,&block)
      Botfly.logger.info("    RSP: Responder##{method}(#{condition.inspect})")
      
      if condition  # method is matcher name
        add_matcher(method,condition)
      else          # method is callback name      
        register_with_bot(method)
      end
      
      if block_given?
        Botfly.logger.info("    RSP: Callback recorded: #{block.inspect}")
        @callback = block 
      end
      
      return self
    end
    
    def callback_with(params)
      Botfly.logger.debug("    RSP: Launching callback with params: #{params.inspect}")

      setup_instance_variables(params)
      if @matcher_chain.all? {|matcher| matcher.match(params) }
        Botfly.logger.debug("      RSP: All matchers passed")
        cb = @callback # Ruby makes it difficult to apply & to an instance variable
        instance_eval &cb
      end
    end
    
    # TODO: Set sensible callable methods
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
    
    # TODO: Check callback is in acceptable list - MUC subclass can override this list
    def register_with_bot(callback_type)
      Botfly.logger.debug("    RSP: Registering :#{callback_type} responder with bot")
      
      @callback_type = callback_type
      if valid_callbacks.include? @callback_type
        @bot.add_responder_of_type(@callback_type,self)
      else
        raise NoMethodError.new("undefined method '#{m}' for #{inspect}:#{self.class}")
      end
    end
    
    def valid_callbacks
      [:message, :presence]
    end
    
    def setup_instance_variables(params)
      raise "AbstractMethodError: You must implement this method in a concrete subclass"
  end
end