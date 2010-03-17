require 'rubygems'
require 'botfly'
require 'fileutils'
require 'yaml'

config = YAML::load(ARGF.read) if ARGF

bot = Botfly.login(config["jid"],config["pass"]) do
  join('lazer').as('retro-bot') do
    on.message.from(/^rkneufeld/).body(/^rb count/) do
      say "All votes are now being tallied. You have three votes, use them wisely"
      say "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      room[:votes] = []
      room[:votes_responder] = on.message.body(/(\d+)+/) do
        @body.scan(/(\d+)+/).map {|m| room[:votes] << m.first.to_i }
      end
    end
    on.message.from(/^rkneufeld/).body(/^rb stop count/) do
      say "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      say "Allright, voting is finished"
      remove room[:votes_responder]
      sorted = room[:votes].inject({}) do |h,n| 
        h[n] ||= 0
        h[n] += 1
        h 
      end.sort {|a,b| b[-1] <=> a[-1] }
      sorted.each {|pair| say "#{pair[0]} => #{pair[-1]} : #{room[:voted][pair[0]].person} - #{room[:voted][pair[0]].name}" }
    end
    on.message.from(/^rkneufeld/).body(/^rb tally$/) do
      room[:tally_responders] = []
      room[:plus] = {}; room[:minus] = {}; room[:delta] = {}
      room[:tally_responders] << on.message.body(/^+(.*)/) { room[:plus][from]  ||= []; room[:plus][from] << match }
      room[:tally_responders] << on.message.body(/^∂(.*)/) { room[:delta][from] ||= []; room[:delta][from] << match }
      room[:tally_responders] << on.message.body(/^-(.*)/) { room[:minus][from] ||= []; room[:minus][from] << match }      
    end
    on.message.from(/^rkneufeld/).body(/^rb stop tally/) do
      # remove responders
      # tally messages
      # stored to room[:voted]
    end
  end
end

Thread.stop;loop
