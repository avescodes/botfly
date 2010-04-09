require 'spec_helper'

include Botfly
describe CallbackContext do
  let(:caller) { mock "Caller" }
  let(:params) { Hash.new }
  subject { CallbackContext.new(caller,params) }
  it "should pass along unknown methods to the caller" do
    caller.should_receive(:foo)
    subject.foo
  end
  it "should pass along complex method calls to the caller" do
    caller.should_receive(:foo).with(:bar,:baz)
    subject.foo(:bar,:baz)
  end
  describe "#setup_params" do
    it "should call setup for each parameter passed" do
      subject.should_receive(:setup_message)
      subject.send(:setup_params, {:message => :foo})
    end
  end
  describe "#expose" do
    it "should define a method that returns value" do
      subject.send(:expose, :foo, :bar)
      subject.foo.should be :bar
    end
    it "should not define methods on the class" do
      expect { CallbackContext.send(:expose, :foo, :bar) }.to raise_error NoMethodError
    end
  end
  context "private setup method" do
    describe "#setup_roster_item" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_roster_item, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_roster_item, :foo)
        subject.roster_item.should be :foo
      end
    end
    describe "#setup_message" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_message, true).should be true }
      it "should set up instance methods for supplied values" do
        message = mock("Message", :to => :to, :from => :from, :chat_state => :chat_state, :type => :type, :subject => subject)
        subject.send(:setup_message, :foo)
        subject.message.should be message
        subject.to.should be :to
        subject.from.should be :form
        subject.chat_state.should be :chat_stae
        subect.type.should be :typed
      end
    end
    describe "#setup_presence" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_presence, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_roster_item, :foo)

      end
    end
    describe "#setup_old_presence" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_old_presence, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_roster_item, :foo)
        subject.roster_item.should be :foo
      end
    end
    describe "#setup_time" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_time, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_roster_item, :foo)
        subject.roster_item.should be :foo
      end
    end
    describe "#setup_nick" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_nick, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_roster_item, :foo)
        subject.roster_item.should be :foo
      end
    end
    describe "#setup_text" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_text, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_roster_item, :foo)
        subject.roster_item.should be :foo
      end
    end
  end
end