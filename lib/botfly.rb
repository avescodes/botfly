require 'rubygems'

require 'xmpp4r'
require 'xmpp4r/muc'

require 'botfly/bot'
require 'botfly/responder'
require 'logger'

module Botfly
  def Botfly.logger
    return @logger || @logger = Logger.new(@logfile)
  end
  def Botfly.login(jid,pass,logfile=STDOUT,&block)
    @logfile = logfile
    Botfly.logger.info("Botfly#login")
    bot = Botfly::Bot.new(jid,pass)
    bot.instance_eval(&block)
    return bot # At this point doesn't get returned, as the thread is stopped
  end
end