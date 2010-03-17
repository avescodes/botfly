module Botfly
  class PresenceResponder < Responder
    def setup_instance_variables(params)
      Botfly.logger.debug("RSP: #{self.class} setting up instance variables")
            
      # TODO: Figure out how xmpp works with presence messages so I know what to expect
      if params[:new]
        @presence = params[:new]      
        @from = @presence.from
        @show = @presence.show
        @priority = @presence.priority
        @status = @presence.status
        @type = @presence.type
      end
      
      if params[:old]
        @old_presence = params[:old]
        @old_status = @old_presence.status
        @old_priority = @old_presence.priority 
        @old_type = @old_presence.type
        @old_show = @old_presence.show
      end
    end
  end
end