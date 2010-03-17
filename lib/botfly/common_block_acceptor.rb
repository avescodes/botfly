module Botfly
  class CommonBlockAcceptor
    extend Forwardable

    attr_accessor :responders  
    attr_reader :client
    
    def initialize
      @block_state = {}
      @responders = {}
    end
    
    def to_debug_s
      raise "AbstractMethodError: Implement in subclass"
    end
    
    ABSTRACT_RAISE_ERROR = "AbstractMethodError: Implement in subclass"
    def to_debug_s;               raise ABSTRACT_RAISE_ERROR; end
    def respond_to(type,params);  raise ABSTRACT_RAISE_ERROR; end
    def on;                       raise ABSTRACT_RAISE_ERROR; end

    def [](key)
      @block_state[key]
    end
    
    def []=(key, set_to)
      @block_state[key] = set_to
    end
    
    class OnRecognizer
      def initialize(obj); @obj = obj; end

      def method_missing(type,prefix='',&block)
        Botfly.logger.info("  #{@obj.to_debug_s}: Bot#on")
        klass = Botfly.const_get(prefix + type.to_s.capitalize + "Responder")
        (@obj.responders[type] ||= []) << responder = klass.new(@obj.client, @obj, &block)
        Botfly.logger.info("  #{@obj.to_debug_s}: #{prefix}#{type.to_s.capitalize}Responder added to responder chain")
        return responder
      end
    end
  end
end