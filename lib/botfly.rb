require 'rubygems'

require 'xmpp4r'
require 'xmpp4r/muc'
require 'xmpp4r/roster'

require 'botfly/common_block_acceptor'
require 'botfly/responder'
require 'botfly/bot'
require 'botfly/matcher'
require 'botfly/muc_client'

require 'logger'
require 'forwardable'

Thread.abort_on_exception = true

module Botfly
  def Botfly.logger
    @logger = Logger.new(@logfile)
    return @logger
  end
  def Botfly.login(jid,pass,logfile=STDOUT,&block)
    @logfile = logfile
    Botfly.logger.info("BOTFLY: #login")
    bot = Botfly::Bot.new(jid,pass)
    bot.connect # Must connect first, since MUC requires an active connection to initiate
    bot.instance_exec(&block)
    return bot # At this point doesn't get returned, as the thread is stopped
  end
end
