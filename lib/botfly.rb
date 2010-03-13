require 'rubygems'

require 'xmpp4r'
require 'xmpp4r/muc'

require 'botfly/bot'
require 'botfly/responder'
require 'logger'

module Botfly
  def Botfly.logger
    return @logger || @logger=Logger.new(STDOUT)
  end
  def Botfly.login(jid,pass,&block)
    Botfly.logger.debug("Botfly#login")
    bot = Botfly::Bot.new('jim','bob')#jid,pass)
    bot.instance_eval(&block)
    Botfly.logger.debug("Done Botfly#login")
    return bot
  end
end