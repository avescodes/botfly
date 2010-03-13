require 'botfly'

Botfly.login("mucker@limun.org/bot","CD.mucker") do
  on.message do
    say("You don't say!")
  end
  connect
end
