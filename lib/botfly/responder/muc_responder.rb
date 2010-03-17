# FIXME: DRY up this and Respnoder 
module Botfly
  class MUCResponder < Responder
     @@id = 1
     extend Forwardable
     
     def_delegator :@muc, :on
     def_delegator :@bot, :client
     def_delegator :@muc, :room
     
     def initialize(muc,&block)
       Botfly.logger.info("RSP: #{self.class.to_s}#new")
       @matcher_chain = []
       @muc = muc
       @bot = @muc.bot

       @callback = block if block_given?
       @id = @@id += 1
     end
     
     def method_missing(method,*args,&block)
       condition = args.first
       Botfly.logger.info("RSP: Responder##{method}(#{condition.inspect})")

       add_matcher(method,condition)

       if block_given?
         Botfly.logger.info("RSP: Callback recorded: #{block.inspect}")
         @callback = block
         return @id
       end

       return self
     end
     
     def callback_with(params)
       Botfly.logger.debug("RSP: Launching callback with params: #{params.inspect}")

       setup_instance_variables(params)
       if @matcher_chain.all? {|matcher| matcher.match(params) }
         Botfly.logger.debug("RSP: All matchers passed")
         cb = @callback # Ruby makes it difficult to apply & to an instance variable
         instance_eval &cb
       end
     end
     
     def leave #room
       raise "NotImplementedError: Sorry, coming soon!"
     end
     
     def say(msg)
       @muc.muc.say(msg)
     end
     
     def remove(responder_id)
       @muc.remove_responder(responder_id)
     end
   private
     def add_matcher(method, condition)
       klass = Botfly.const_get("MUC" + method.to_s.capitalize + "Matcher")
       @matcher_chain << klass.new(condition)

       Botfly.logger.debug("RSP: Adding to matcher chain: #{@matcher_chain.inspect}")
     end

     def setup_instance_variables(params)
       @text = @body = params[:text]
       @nick = @from = params[:nick]
       @time = params[:time]
     end     
  end
end