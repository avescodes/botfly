#if @matcher_chain.all? {|matcher| matcher.match }
module Botfly
  class Responder
    def initialize
      Botfly.logger.debug("Responder#new")
      @matcher_chain = []
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
  end
end