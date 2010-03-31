require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Botfly::Bot do
  context "initializer" do
    before(:each) { @bot = Botfly::Bot.new('jid','pass', :gtalk => true) }
    it "should make a call to CommonBlockAcceptor initialize with super" do
      @bot.responders.should be_a Hash # TODO: This is a really coupled way of checking for this
    end
    it "should set host for gtalk if gtalk option is true" do
      @bot.host.should == 'talk.google.com'
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
end
