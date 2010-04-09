module Botfly
  class Responder
    @@id = 1
    include Botfly::CommonResponderMethods
    extend Forwardable

    attr_reader :callback, :callback_type, :id, :bot
    def_delegator :@bot, :client
    def_delegator :@bot, :quit
    
    def initialize(bot,&block)
      Botfly.logger.info("RSP: #{self.class.to_s}#new")
      @matcher_chain = []
      @bot = bot
      @callback = block if block_given?
      @id = @@id += 1
    end
    
    ##
    # Allows for the nifty DSL that lets you chain matchers after specifying a callback type.
    #
    # 
    # e.g. on.message.matcher1(:foo).matcher2(:bar) { ... }
    #
    # @param [String] method The name of the matcher to be added to the matcher chain
    # @param condition The condition or set of conditions to be matched against when attempting execution.
    # @return [self] Chain to your hearts content.
    def method_missing(method,condition,&block)
      Botfly.logger.info("RSP: Responder##{method}(#{condition.inspect})")
      
      add_matcher(method,condition)
      
      if block_given?
        Botfly.logger.info("RSP: Callback recorded: #{block.inspect}")
        @callback = block
        return @id
      end
      
      return self
    end
    
    ##
    # Attempt to execute the callback on a responder. Only called if all matchers pass based on the supplied params
    #
    # @param [Hash] params The parameters necessary to execute the callback. Supplied by xmpp4r and pass through to here.
    def callback_with(params)
      Botfly.logger.debug("RSP: Launching callback with params: #{params.inspect}")

      context = callback_context(params)
      if @matcher_chain.all? {|matcher| matcher.match(params) }
        Botfly.logger.debug("RSP: All matchers passed")
        cb = @callback # Ruby makes it difficult to apply & to an instance variable
        context.instance_eval &cb
      end
    end

    # TODO: add other @client actions as delegates    

  private
    def add_matcher(method, condition)
      klass = Botfly.const_get(method.to_s.split('_').map(&:capitalize).join + "Matcher")
      @matcher_chain << klass.new(condition)
      
      Botfly.logger.debug("RSP: Adding to matcher chain: #{@matcher_chain.inspect}")
    end

    def callback_context(params)
      Botfly::CallbackContext.new(self, params)
    end
  end
end
