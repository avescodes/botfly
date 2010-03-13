require 'rubygems'
require 'botfly'

require 'yaml'

config = YAML::load(ARGF.read) if ARGF
puts config.inspect

#Jabber::debug = true

bot = Botfly.login(config["jid"],config["pass"]) do
  on.message.nick(/rkneufeld/) do
    Botfly.logger.info("Callback called")
    reply("ummmm, no")
  end
  connect
end
Thread.stop
loop{}
