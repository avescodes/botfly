require 'rubygems'

require 'xmpp4r'
require 'xmpp4r/muc'

require 'botfly/bot'
#require logger

module Botfly
  def login(jid,pass,&block)
    bot = Botfly::Bot.new(jid,pass)
    bot.instance_eval(&block)
  end
end
    