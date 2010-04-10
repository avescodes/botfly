module Botfly
  class CallbackContext
    def initialize(caller, params)
      setup_params(params)
      @caller = caller
    end
    def method_missing(name, *args)
      @caller.send(name,*args) if name.to_s.scan(/^setup/).empty?
    end
  private
    # OK, so. Get the instance's eigenclass, then, call the private method define_method - thus created the method called #{name} that returns value. Basically attr_reader but for any generic variable.
    def expose(name, value)
      (class<<self;self;end).send(:define_method,name,proc{value})
    end
    def setup_params(params)
      params.each do |name,value|
        send(:"setup_#{name}", value)
      end
    end
    def setup_roster_item(roster_item)
      expose(:roster_item, roster_item)
    end
    def setup_message(message)
      expose(:message, message)
      expose(:body, message.body)
      expose(:chat_state, message.chat_state)
      expose(:subject, message.subject)
      expose(:type, message.type)
      expose(:from, message.from)
      expose(:to, message.to)
    end
    def setup_presence(presence, pre = '')
      expose(:"#{pre}presence", presence)
      expose(:"#{pre}from", presence.from)
      expose(:"#{pre}show", presence.show)
      expose(:"#{pre}priority", presence.priority)
      expose(:"#{pre}status", presence.status)
      expose(:"#{pre}type", presence.type)
    end
    def setup_old_presence(presence); setup_presence(presence, 'old_') end
    def setup_time(time); expose(:time, time) end
    def setup_nick(nick); expose(:from, nick); end
    def setup_text(text); expose(:text, text); expose(:body, text); end
  end
end
