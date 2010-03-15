require 'rubygems'
require 'botfly'

require 'yaml'

config = YAML::load(ARGF.read) if ARGF
puts config.inspect

Jabber::debug = false

bot = Botfly.login(config["jid"],config["pass"]) do
  on(:message).body(/^exit$/) { reply "Goodbye!"; quit }
  on(:message).nick(/rkneufeld/) do
    Botfly.logger.info("Callback called")
    @count ||= 0
    @count += 1
    reply("That's the #{@count}th message I've received.")
  end

  on(:presence) { send("rkneufeld","Got presence #{@status} from #{@from}") }
  connect
end
Thread.stop
loop{}
