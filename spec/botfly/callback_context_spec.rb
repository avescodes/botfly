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
    let(:presence) do
      stub("Presence", :from => :from, :show => :show, :priority => :priority,
        :status => :status, :type => :type)
    end
    let(:message) do
      stub("Message", :body => :body, :to => :to, :from => :from, 
        :chat_state => :chat_state, :type => :type, :subject => subject) 
    end
    
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
        subject.send(:setup_message, message)
        subject.message.should be message
        subject.body.should be message.body
        subject.to.should be message.to
        subject.from.should be message.from
        subject.chat_state.should be message.chat_state
        subject.type.should be message.type
      end
    end
    
    describe "#setup_presence" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_presence, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_presence, presence)
        subject.presence.should be :presence
        subject.from.should be :from
        subject.show.should be :show
        subject.priority.should be :priority
        subject.status.should be :status
        subject.type.should be :type
      end
    end
    
    describe "#setup_old_presence" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_old_presence, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_old_presence, presence)
        subject.old_presence.should be :presence
        subject.old_from.should be :from
        subject.old_show.should be :show
        subject.old_priority.should be :priority
        subject.old_status.should be :status
        subject.old_type.should be :type
      end
    end
    
    describe "#setup_time" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_time, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_time, :foo)
        subject.time.should be :foo
      end
    end
    
    describe "#setup_nick" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_nick, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_nick, :foo)
        subject.from.should be :foo
      end
    end
    
    describe "#setup_text" do
      subject { CallbackContext.new(caller,params) }
      it { subject.respond_to?(:setup_text, true).should be true }
      it "should set up instance methods for supplied values" do
        subject.send(:setup_text, :foo)
        subject.text.should be :foo
        subject.body.should be :foo
      end
    end
  end
end