module Botfly
  class Responder
    attr_reader :callback, :callback_type
    
    def initialize(client,bot,&block)
      Botfly.logger.info("    RSP: #{self.class.to_s}#new")
      @matcher_chain = []
      @bot = bot
      @client = client
      @callback = block if block_given?
    end
    
    def method_missing(method,condition=nil,&block)
      Botfly.logger.info("    RSP: Responder##{method}(#{condition.inspect})")
      
      add_matcher(method,condition)
      
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
      raise "AbstractMethodError: You must implement this method in a concrete subclass"
    end      

    def setup_instance_variables(params)
      raise "AbstractMethodError: You must implement this method in a concrete subclass"
    end
  end
end