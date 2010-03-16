require 'forwardable'
module Botfly
  class Responder
    @@id = 1
    include Botfly::CommonResponderMethods
    extend Forwardable

    attr_reader :callback, :callback_type, :id, :bot
    def_delegator :@bot, :client
    
    def initialize(client,bot,&block)
      Botfly.logger.info("    RSP: #{self.class.to_s}#new")
      @matcher_chain = []
      @bot = bot
      @client = client
      @callback = block if block_given?
      @id = @@id += 1
    end
    
    def method_missing(method,condition,&block)
      Botfly.logger.info("    RSP: Responder##{method}(#{condition.inspect})")
      
      add_matcher(method,condition)
      
      if block_given?
        Botfly.logger.info("    RSP: Callback recorded: #{block.inspect}")
        @callback = block
        return @id
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

    def quit
      @bot.quit
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
