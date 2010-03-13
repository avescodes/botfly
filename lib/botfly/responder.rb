module Botfly
  class Responder
    def initialize
      @matcher_chain = []
    end
    def method_missing(method,condition=nil)
      if condition  # method is matcher name
        klass = Botfly.const_get(method.capitalize + "Matcher")
        @matcher_chain << klass.new(condition)
        #could rescue NameError, but this way we raise that it doesn't exist
      else          # method is callback name      
        # TODO: Check callback is in acceptable list - MUC subclass can override this list
        @callback = method.to_sym
      end
      call if block_given? && @callback
      return self
    end
  end
end