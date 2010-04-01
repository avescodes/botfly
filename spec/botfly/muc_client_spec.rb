require 'spec_helper'

include Botfly
describe Botfly::MUCClient do
  context "initializer" do
    let(:jid) { stub("JID", :domain => 'domain.com', :node => 'resource') }
    let(:bot) { stub("Bot", :client => stub_jabber_client, :jid => jid) }
    subject { MUCClient.new("Room", bot) { } }

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
    it "should expose access to @block_state"
  end

  describe "#execute" do
    it "should connect before running"
    it "should execute block"
  end

  describe "#connect" do
    it "should create an xmpp4r MUC Client"
    it "should register for callbacks"
    it "should compose a jid"
    it "should record connected_at time"
    it "should join the room as jid"
    it "should complete all steps in order"
  end

  describe "#as" do 
    it "should assign a resource"
    it "should execute if given a block"
  end

  describe "#leave_room" do
    it "should leave the chat room"
  end

  describe "#respond_to" do
    it "shouldn't respond old messages"
    it "should respond to regular messages"
  end

  describe "#register_for_callbacks" do
    #let(:bot) { Bot.new('jid', 'pass') }
    #before(:each) { stub_jabber_client }
    let(:muc) { pending "Stub class and assign MUC" }
    it "should register calls for each callback" do
      [:join, :leave, :message, :room_message, :self_leaeve, :subject].each do |type|
        muc.should_receive(:"on_#{type}")
      end
      muc.send(:register_for_callbacks)
    end
  end
end
