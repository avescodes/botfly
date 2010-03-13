module Botfly
  class PresenceResponder < Responder
    def setup_instance_variables(params)
      Botfly.logger.debug("    RSP: #{self.class} setting up instance variables")
    end
  end
end