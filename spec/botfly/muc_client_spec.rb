require 'spec_helper'

include Botfly
describe Botfly::MUCClient do
  let(:jid) { stub("JID", :domain => 'domain.com', :node => 'resource') }
  let(:bot) { stub("Bot", :client => stub_jabber_client, :jid => jid) }
  let(:muc) do
    cbs = [:join, :leave, :message, :room_message, :self_leave, :subject]
    cbs = cbs.inject({}) { |h,cb| h[:"on_#{cb}"] = nil; h }
    muc = stub("Jabber::MUC::SimpleMUCClient", cbs.merge(:join => nil))
    muc
  end
  let(:muc_client) { MUCClient.new("Room", bot) { } }
  context "initializer" do
    subject { muc_client }

    [:bot, :client, :room, :domain, :resource].each do |ivar|
      it { should assign ivar }
    end
    its(:domain) { should == 'conference.domain.com' }
    its(:resource) { should == 'resource' }
    it "should run the passed block" do
      expect { MUCClient.new("Room", bot) {raise "ran!"} }.to raise_error "ran!"
    end
  end

  describe "#room" do
    it "should expose access to @block_state" do
      muc_client.room.should == muc_client.instance_variable_get("@block_state")
    end
  end

  describe "#execute" do
    it "should connect before running" do
      muc_client.should_receive(:connect).ordered
      muc_client.should_receive(:instance_eval).ordered
      muc_client.as("foo") {}
    end
    it "should execute block" do
      block = lambda { raise "Ran" }
      expect { muc_client.send(:execute, &block) }.to raise_error "Ran"
    end

  end

  describe "#connect" do
    let(:muc_client) { MUCClient.new("Room", bot) }  
    after(:each) { muc_client.send(:connect) }
    it "should complete all steps in order" do
      Jabber::MUC::SimpleMUCClient.should_receive(:new).ordered.and_return(muc)
      muc_client.should_receive(:register_for_callbacks).ordered
      muc.should_receive(:join).ordered
    end
  end

  describe "#as" do
    subject { muc_client }
    it "should assign resource to given" do
      muc_client.as(:the_boss)
      muc_client.resource.should be :the_boss
    end
    it "should execute if given a block" do
      expect { muc_client.as(:foo) { raise "Ran" }}.to raise_error "Ran"
    end
  end

  describe "#leave" do
    it "should leave the chat room" do 
      muc_client.muc.should_receive(:exit)
      muc_client.leave
    end
  end

  describe "#respond_to" do
    it "should respond to with appropriate responder" do
      muc_client.responders[:foo] = [stub("responder", :callback_with => nil)]
      muc_client.send(:respond_to, :foo)
    end
    it "should tell xmpp4r not to send history" do
      muc.should_receive(:join).with(anything, nil, hash_including(:history => false))
      Jabber::MUC::SimpleMUCClient.stub(:new).and_return(muc)
      muc_client.send(:connect)
    end
  end

  describe "#register_for_callbacks" do
    it "should register calls for each callback" do
      Jabber::MUC::SimpleMUCClient.stub(:new).and_return(muc)
      [:join, :leave, :message, :room_message, :self_leave, :subject].each do |type|
        muc.should_receive(:"on_#{type}")
      end
      muc_client.send(:register_for_callbacks)
    end
  end
end
