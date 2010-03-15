module Botfly
  class PresenceResponder < Responder
    def setup_instance_variables(params)
      Botfly.logger.debug("    RSP: #{self.class} setting up instance variables")
      @old_presence = params[:old]
      @presence = params[:new]
      
      @from = @presence.from
      @show = @presence.show
      @priority = @presence.priority
      @status = @presence.status
      @type = @presence.type
      
      @old_status = @old_priority.status
      @old_priority = @old_priority.priority 
      @old_type = @old_priority.type
      @old_show = @old_priority.show
    end
  end
end