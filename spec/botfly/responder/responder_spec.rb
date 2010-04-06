require 'spec_helper'

include Botfly
describe Botfly::Responder do
  describe ".new" do
    subject { Responder.new(mock("bot")) }
    it { should assign :matcher_chain }
    it { should assign :bot }
    it { should_not assign :callback }
    it "should assign callback if block given" do
      proc = Proc.new {}
      Responder.new(mock("bot"), &proc).should assign :callback
    end
    it "should give out incremental IDs" do
      bot = mock("bot")
      @id = Responder.new(bot).id
      expect { @id = Responder.new(bot).id }.to change {@id}.by(1)
    end
  end

  it "should include CommonResponderMethods?"

  context "instance" do
    let(:bot) { mock "bot" }
    subject { Responder.new(bot) }
    it "should delegate client to @bot" do
      bot.should_receive :client
      subject.client
    end
    it "should delegate quit to @bot" do
      bot.should_receive :quit
      subject.quit
    end
    it "should provide attr_reader for @bot" do
      subject.bot.should be bot
    end
  end

  describe "#method_missing" do
    subject { Responder.new(mock("bot")) }
    before(:all) { class FooMatchMatcher < Matcher; end }
    it "should add matcher" do
      subject.should_receive(:add_matcher).with(:foo_match,:bar)
      subject.foo_match(:bar)
    end
    it "should assign callback if block given" do
      expect { subject.foo_match(:bar) { :baz } }.to change { subject.instance_variable_get(:'@callback') }
    end
    it "should return self" do
      subject.foo_match(:bar).should be subject
    end
  end

  describe "#add_matcher" do
  end
  
  describe "#callback_with" do
    it "should create callback context"
    it "should execute callback in created context"
  end
  
  describe "#create_callback_context" do
    it "should return an anonymous class"
    it "should set up instance methods on that class to give access to callback parameters"
    it "should send non-instance method calls back to the responder"
  end

end
