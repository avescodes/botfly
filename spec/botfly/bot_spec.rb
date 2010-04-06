require 'spec_helper'

include Botfly
describe Botfly::Bot do
  context "initializer" do
    subject { Bot.new('jid','pass', :gtalk => true) }
    its(:responders) { should be_a Hash }# TODO: This is a really coupled way of checking for super being called
    context "gtalk option is true" do
      its(:host) { should == 'talk.google.com' }
    end
  end

  context "instance" do
    subject { Bot.new('jid','pass') }
    context "readers & accessors" do
      it { should respond_to :client }
      it { should respond_to :roster }
      it { should respond_to :responders }
      it { should respond_to :host }
      it { should respond_to :jid }
    end
    it { should respond_to :connect }
    it { should respond_to :join }
    it { should respond_to :quit }
    it { should respond_to :[] }
    it { should respond_to :[]= }
    it { should respond_to :on }
    it { should respond_to :remove_responder }
  end

  describe "#register_for_callbacks" do
    subject { Bot.new('jid', 'pass') }
    before(:each) { stub_jabber_client; }
    after(:each)  { subject.send(:register_for_callbacks)}
    it "should register calls for each callback" do
      subject.instance_variable_set(:"@roster", mock("roster")) # I would prefer to do this elsewhere
      subject.roster.should_receive :add_subscription_request_callback
      subject.client.should_receive :add_presence_callback
      subject.client.should_receive :add_message_callback

    end
  end

  describe "#connect" do
    let(:bot) { Bot.new('jid','pass') }
    subject { bot }
    after(:each) { bot.connect }
    it "should execute methods in order" do
      bot.client.should_receive(:connect).once.ordered
      bot.client.should_receive(:auth).once.ordered
      Jabber::Roster::Helper.should_receive(:new).with(bot.client).once.ordered
      bot.should_receive(:register_for_callbacks).once.ordered
    end
  end

  describe "#quit" do
    let(:bot) { Bot.new('jid','pass') }
    after(:each) { bot.quit }
    specify { bot.client.should_receive(:close) }
    specify { Thread.current.should_receive(:wakeup) }
  end

  describe "#join" do
    let(:bot) { Bot.new('jid','pass') }
    specify { MUCClient.should_receive(:new).with('foo', bot); bot.join('foo') {} }
  end

  describe "#respond_to" do
    let(:bot) { Bot.new('jid', 'params') }
    let(:responder)  { mock "responder" }
    let(:responders) { [responder] }
    before(:each) { bot.responders[:foo] = responders;  }
    it "should find responders in the responder chain" do
      bot.responders.should_receive(:[]).with(:foo)
      bot.send(:respond_to, :foo, :bar)
    end
    it "should call #callback_with_params if responder exists for type" do
      responder.should_receive(:callback_with).with(:bar)
      bot.send(:respond_to, :foo, :bar)
    end
    it "should do nothing if no responder exists for callback" do
      bot.responders.should_receive(:[]).with(:bar)
      responder.should_not_receive(:callback_with)
      bot.send(:respond_to, :bar, :foo)
    end
  end

end
