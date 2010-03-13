require 'rubygems'
require 'botfly'

require 'yaml'

# config = YAML::load(ARGF.read) if ARGF
# puts config.inspect
config = { "jid" => "mucker@limun.org/bot", "pass" => "CD.mucker" }
bot = Botfly.login(config["jid"],config["pass"]) do
  on.message.nick(/rkneufeld/) do
    say("You don't say!")
  end
  connect
end
#loop {}