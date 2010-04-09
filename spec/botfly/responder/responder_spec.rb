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
    it { should be_a CommonResponderMethods }
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
    subject { Responder.new(mock("bot")) }
    before(:all) { class FooBarMatcher; def initialize(*args); end; end }
    it "should map matcher name to proper class" do
      FooBarMatcher.should_receive(:new)
      subject.send(:add_matcher, :foo_bar, :baz)
    end
    it "should add instanciated matcher to matcher chain" do
      expect { subject.send(:add_matcher, :foo_bar, :baz) }.to change { subject.instance_variable_get(:'@matcher_chain').count }.by(1)
    end
  end
  
  describe "#callback_with" do
    subject { Responder.new(mock "bot") }
    let(:params) { double "params" }
    after(:each) { subject.callback_with(params) }
    it "should create callback context" do
      CallbackContext.should_receive(:new).with(subject, params)
      subject.instance_variable_set(:"@callback", Proc.new {} )
    end
    it "should execute callback in created context" do
      context = mock("Context", :foo => :bar)
      CallbackContext.should_receive(:new).and_return(context)
      context.should_receive(:instance_eval)
    end
  end
  
  describe "#callback_context" do
    specify { Responder.new(mock("bot")).send(:callback_context, :foo).should be_a CallbackContext }
  end
end
