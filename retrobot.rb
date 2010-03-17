require 'rubygems'
require 'botfly'
require 'fileutils'
require 'yaml'

config = YAML::load(ARGF.read) if ARGF
Jabber::debug = true
bot = Botfly.login(config["jid"],config["pass"]) do
  join('lazer').as('retro-bot') do
    on.message.from(/^rkneufeld/).body(/retro: start count/) do
      say "All votes are now being tallied. You have three votes, use them wisely"
      say "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      room[:votes] = []
      room[:votes_responder] = on.message.body(/(\d+)+/) do
        @body.scan(/(\d+)+/).map {|m| room[:votes] << m.first.to_i }
      end
    end
    on.message.from(/^rkneufeld/).body(/retro: stop count/) do
      say "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      say "Allright, voting is finished"
      remove room[:votes_responder]
      room[:votes].inject({}) do |h,n| 
        h[n] ||= 0
        h[n] += 1
        h 
      end.sort {|a,b| b[-1] <=> a[-1] }.each {|pair| puts "#{pair[0]} => #{pair[-1]}" }
    end
  end
end

Thread.stop;loop
