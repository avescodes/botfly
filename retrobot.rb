require 'rubygems'
require 'botfly'
require 'fileutils'
require 'yaml'

config = YAML::load(ARGF.read) if ARGF
Jabber::debug  = true
bot = Botfly.login(config["jid"],config["pass"]) do
  join('lazer').as('retro-bot') do
    on.message.from(/^rkneufeld/).body(/^rb count/) do
      say "All votes are now being tallied. You have three votes, use them wisely"
      say  "================="
      room[:votes] = []
      room[:votes_responder] = on.message.body(/(\d+)+/) do
        @body.scan(/(\d+)+/).map {|m| room[:votes] << m.first.to_i }
      end
    end
    on.message.from(/^rkneufeld/).body(/^rb stop count/) do
      say  "================="
      say "Allright, voting is finished"
      remove room[:votes_responder]
      sorted = room[:votes].inject({}) do |h,n| 
        h[n] ||= 0
        h[n] += 1
        h 
      end.sort {|a,b| b[-1] <=> a[-1] }
      sorted.each {|pair| say "#{pair[0]} => #{pair[-1]}"}#)}" : #{room[:voted][pair[0]].person} - #{room[:voted][pair[0]].name}" }
    end
    on.message.from(/^rkneufeld/).body(/^rb tally$/) do
      say "Tally HO! Please start your message with +, -, or ∂ (that's option-d) to have it tallied up"
      say "================="
      room[:tally_responders] = []; room[:tally] = {}
      room[:plus] = {}; room[:minus] = {}; room[:delta] = {}

      room[:tally_responders] << on.message.body(/^\+(.*)/) { room[:tally][@from]  ||= []; room[:tally][@from] << @body }
      room[:tally_responders] << on.message.body(/^d (.*)/)  { room[:tally][@from]  ||= []; room[:tally][@from] << @body }
      room[:tally_responders] << on.message.body(/^-(.*)/)  { room[:tally][@from]  ||= []; room[:tally][@from] << @body }
    end
    on.message.from(/^rkneufeld/).body(/^rb stop tally/) do
      room[:tally_responders].each { |id| remove id }
      room[:tally]
      # stored to room[:voted]
    end
  end
end

Thread.stop;loop
