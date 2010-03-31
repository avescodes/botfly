require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def stub_jabber_client
  @client = stub("Client", :connect => nil, 
                           :auth => nil,
                           :add_message_callback => nil,
                           :add_presence_callback => nil) 
  Jabber::Client.should_receive(:new).and_return(@client)
end

describe Botfly do
  describe "module" do
    it "should return a logger" do
      Botfly.logger.should be_a Logger
    end
  end
  context "login" do
    it "should connect before evaluation of block" do
      @bot = mock("bot") 
      Botfly::Bot.stub(:new).and_return(@bot)
      @bot.should_receive(:connect).ordered.once
      @bot.should_receive(:instance_exec).ordered.once
      Botfly.login('jid','pass')
    end
    it "should create a new bot" do
      stub_jabber_client
      bot = Botfly.login('jid','pass')
      bot.should be_a Botfly::Bot
    end
  end
end
