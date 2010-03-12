require 'rubygems'
require 'xmpp4r'
require 'xmpp4r/muc'

jid = 'mucker@limun.org/mucbot'
pass = 'CD.mucker'

class Bot
  def initialize(jid,pass)
    @jid = Jabber::JID.new(jid)
    @password = pass
    @client = Jabber::Client.new(@jid)
  end
  
  def connect
    @client.connect
    @client.auth(@password)
  end
  
  def join_room(room, server="#{room}@conference.#{@client.jid.domain}",as="#{@client.jid.node}-#{@client.jid.resource}")
    jid = [server,as].join('/')
    muc_client = Jabber::MUC::SimpleMUCClient.new(@client)
    muc_client.on_message { |time, nick, body| some_method(muc_client, as, time, nick, body)}
    muc_client.join(Jabber::JID.new(jid))
#    muc_client.say "Hey folks!"
    @muc_connections ||= []
    @muc_connections << muc_client
  end
  
  def some_method(muc,my_nick,time,nick,body)
    puts "Message received"
    muc.say("Got message \"#{body}\" from #{nick} at #{time}") unless body =~ /Got message/ 
  end
end

if __FILE__ == $0
  @bot = Bot.new(jid,pass)
  @bot.connect
  @bot.join_room("bot-test")
  loop {}
end