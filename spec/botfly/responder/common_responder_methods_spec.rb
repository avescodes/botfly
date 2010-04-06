require 'spec_helper'

include Botfly
describe CommonResponderMethods do
  let(:bot) { stub("Bot", :client => stub("client"))}
  let(:responder) do
    class Responder; include CommonResponderMethods; end;
    Responder.new(bot)
  end

  describe "#remove" do
    # Don't test all of #remove_responder, that's tested elsewhere ;)
    it "should ask class's bot to remove responder of given id" do
      bot.should_receive(:remove_responder).with(:foo)
      responder.remove(:foo)
    end
  end

  describe "#send" do
    before(:each) do
      responder.bot.stub_chain(:jid,:domain => 'foo.com')
    end
    after(:each) { responder.send('foo@bar.baz/home', "message") }
    subject { responder }
    
    it "should pass the message along to the bot's jabber client" do
      responder.client.should_receive(:send).with(an_instance_of(Jabber::Message))
    end

    it "should set the nickname and body appropriately in the message" do
      responder.client.should_receive(:send) do |msg|
        msg.to.to_s.should == 'foo@bar.baz/home'
        msg.body.should == 'message'
      end
    end
  end
end