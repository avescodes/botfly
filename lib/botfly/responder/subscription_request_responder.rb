module Botfly
  class SubscriptionRequestResponder < Responder    
    extend Forwardable
    def setup_instance_variables(params)
      Botfly.logger.debug("    RSP: SubscriptionRequestResponder setting up instance variables")
      @roster_item = params[:roster_item]
      @presence = params[:presence]
      @from = @presence.from
    end
    
    def accept
      @bot.roster.accept_subscription(@from)
    end
    def decline
      @bot.roster.decline_subscription(@from)
  end
end