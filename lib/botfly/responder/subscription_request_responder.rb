module Botfly
  class SubscriptionRequestResponder < Responder    
    extend Forwardable    
    def accept
      @bot.roster.accept_subscription(@from)
    end
    def decline
      @bot.roster.decline_subscription(@from)
    end
  end
end