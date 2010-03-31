require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Botfly do
  describe ".logger" do
    subject { Botfly.logger }
    it { should be_a Logger }
  end

  describe ".login" do
    it "should connect before evaluation of block" do
      @bot = mock("bot") 
      Botfly::Bot.should_receive(:new).and_return(@bot)
      @bot.should_receive(:connect).ordered.once
      @bot.should_receive(:instance_exec).ordered.once
      Botfly.login('jid','pass')
    end
    it "should create a new bot" do
      stub_jabber_client
      bot = Botfly.login('jid','pass') { }
      bot.should be_a Botfly::Bot
    end
  end
end
