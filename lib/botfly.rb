require 'rubygems'

require 'logger'
require 'forwardable'

require 'xmpp4r'
require 'xmpp4r/muc'
require 'xmpp4r/roster'

require 'botfly/common_block_acceptor'
require 'botfly/responder'
require 'botfly/bot'
require 'botfly/matcher'
require 'botfly/muc_client'


Thread.abort_on_exception = true

module Botfly
  def Botfly.logger
    @logger ||= Logger.new(@logfile)
    return @logger
  end
  def Botfly.login(jid,pass,opts={},logfile=STDOUT,&block)
    @logfile = logfile
    Botfly.logger.info("BOTFLY: #login")
    bot = Botfly::Bot.new(jid,pass,opts)
    bot.connect # Must connect first, since MUC requires an active connection to initiate
    bot.instance_exec(&block)
    return bot # At this point doesn't get returned, as the thread is stopped
  end
end
