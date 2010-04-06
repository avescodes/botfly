module Botfly
  class CommonBlockAcceptor
    extend Forwardable

    attr_reader :block_state, :responders
    
    def initialize(*ignored)
      @block_state = {}
      @responders = {}
    end
    
    def respond_to(type,params);  
      raise "AbstractMethodError: Implement in subclass" 
    end

    def [](key)
      @block_state[key]
    end
    
    def []=(key, set_to)
      @block_state[key] = set_to
    end

    def remove_responder(id_to_remove)
      Botfly.logger.info("#{self.to_debug_s}: Removing responder #{id_to_remove}")
      @responders.each { |pair| key,chain = pair; chain.reject! {|r| r.id == id_to_remove } }
    end
    
    def on
      return OnRecognizer.new(self)
    end
    
    class OnRecognizer
      def initialize(obj); @obj = obj; end

      def method_missing(name,&block)
        Botfly.logger.info("#{@obj.to_debug_s}: Bot#on")
        klass = Botfly.const_get(@obj.class_prefix + name.to_s.split('_').map(&:capitalize).join + "Responder")
        (@obj.responders[name] ||= []) << responder = klass.new(@obj, &block)
        Botfly.logger.info("#{@obj.to_debug_s}: #{@obj.class_prefix}#{name.to_s.capitalize}Responder added to responder chain")
        return responder
      end
    end
    
    def class_prefix; ''; end
    def to_debug_s;   ''; end

  end
end
