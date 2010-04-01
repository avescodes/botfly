require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Botfly::Bot do
  context "initializer" do
    subject { Botfly::Bot.new('jid','pass', :gtalk => true) }
    its(:responders) { should be_a Hash }# TODO: This is a really coupled way of checking for this
    context "gtalk option is true" do
      its(:host) { should == 'talk.google.com' }
    end
  end

  context "object" do
    subject { Botfly::Bot.new('jid','pass') }
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
    subject { Botfly::Bot.new('jid', 'pass') }
  end

  describe "#connect" do
    it "should be tested"
  end

  describe "#quit" do
    it "should be tested"
  end

  describe "#join" do
    it "should be tested"
  end

  describe "#respond_to" do
    it "should be tested"
  end

end
