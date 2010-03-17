module Botfly
  class CommonBlockAcceptor
    extend Forwardable

    attr_accessor :responders  
    attr_reader :client
    
    def initialize(ignored,ignore)
      @block_state = {}
      @responders = {}
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

    def remove_responder(id_to_remove)
      Botfly.logger.info("  BOT: Removing responder #{id_to_remove}")
      @responders.each { |pair| key,chain = pair; chain.reject! {|r| r.id == id_to_remove } }
    end
    
    def on
      return OnRecognizer.new(self)
    end
    
    class OnRecognizer
      def initialize(obj); @obj = obj; end

      def method_missing(type,&block)
        Botfly.logger.info("  #{@obj.to_debug_s}: Bot#on")
        klass = Botfly.const_get(@obj.class_prefix + type.to_s.capitalize + "Responder")
        (@obj.responders[type] ||= []) << responder = klass.new(@obj, &block)
        Botfly.logger.info("  #{@obj.to_debug_s}: #{@obj.class_prefix}#{type.to_s.capitalize}Responder added to responder chain")
        return responder
      end
    end
    
    def class_prefix
      ''
    end
  end
end