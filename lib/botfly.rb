require 'rubygems'

require 'xmpp4r'
require 'xmpp4r/muc'

require 'botfly/responder'
require 'botfly/bot'
require 'botfly/matcher'
require 'botfly/muc_client'

require 'logger'


module Botfly
  def Botfly.logger
    @logger = Logger.new(@logfile)
    return @logger
  end
  def Botfly.login(jid,pass,logfile=STDOUT,&block)
    @logfile = logfile
    Botfly.logger.info("BOTFLY: #login")
    bot = Botfly::Bot.new(jid,pass)
    bot.instance_eval(&block)
    return bot # At this point doesn't get returned, as the thread is stopped
  end
end