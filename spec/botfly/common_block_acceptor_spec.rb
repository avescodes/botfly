require 'spec_helper'

include Botfly
describe CommonBlockAcceptor do
  describe "initialize" do
    its(:block_state) { should == {} }
    its(:responders)  { should == {} }
  end

  context "object" do
    [:responders, :block_state, :[], :[]=, :on, :remove_responder].each do |m|
      it { should respond_to m }
    end
    describe "#[]" do
      let(:acceptor) { CommonBlockAcceptor.new }
      it "should provide hash-like access to block_state" do
        acceptor[:foo] = :bar
        acceptor[:foo].should be :bar
      end
    end
  end

  context "abstract method" do
    let(:acceptor) { CommonBlockAcceptor.new }
    specify { expect { acceptor.respond_to(nil,nil) }.to raise_error /AbstractMethodError/ }
  end

  describe '#remove_responder' do
    let(:acceptor) { CommonBlockAcceptor.new }
    let(:responder) { stub :id => 1 }
    before(:each) { acceptor.responders[:foo] = [responder] }
    it "should remove responder with given id from the chain" do
      expect { acceptor.remove_responder(1)}.to change { acceptor.responders.values.flatten.count }.to 0 # FIXME: Refactor from Hash to actual ResponderChain object
    end
  end

  describe "#class_prefix" do
    let(:acceptor) { CommonBlockAcceptor.new }
    its(:class_prefix) { should be_empty }
  end

  describe "#on" do
    subject { CommonBlockAcceptor.new.on }
    it { should be_an CommonBlockAcceptor::OnRecognizer }
  end

  context "::OnRecognizer" do
    let(:acceptor) { CommonBlockAcceptor.new }
    let(:on) { acceptor.on } 
    before(:all) do
      class FooResponder; def initialize(bar); end; end
      class FooBarResponder; def initialize(baz);end; end
    end

    it "should instanciate specialized responder based on name if class exists" do
      FooResponder.should_receive(:new)
      on.foo
    end
    
    it "should turn snake_case into CamelCase" do
      FooBarResponder.should_receive(:new)
      on.foo_bar
    end
    
    it "should add class prefix to front of responder class" do
      acceptor.stub(:class_prefix).and_return('Foo')
      Botfly.should_receive(:const_get).with('FooBarResponder').and_return(FooBarResponder)
      on.bar.should be_a_kind_of FooBarResponder
    end
      
    it "should add responder to object's responder chain hash" do
      FooResponder.stub(:new).and_return(:foo_instance)
      acceptor.responders.should == {}
      expect { on.foo }.to 
        change { acceptor.responders }.
          from({}).to({:foo => [:foo_instance]})
    end

    it "should return the responder itself" do
      FooResponder.stub(:new).and_return(:foo_instance)
      on.foo.should be :foo_instance
    end
    
    it "should default to Responder for basic responder" do
      Responder.stub(:new).and_return(:plain)
      on.baz.should be :plain
    end
    
    it "should still add class prefix even if special responder not found" do
      acceptor.stub(:class_prefix).and_return('Foo')
      FooResponder.stub(:new).and_return(:plain)
      on.baz.should be :plain
    end
  end
end

