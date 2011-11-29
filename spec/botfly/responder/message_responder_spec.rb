require 'spec_helper'

include Botfly
describe Botfly::MessageResponder do
  let(:bot) { mock "bot" }
  subject { MessageResponder.new(bot) }
  it { should respond_to :reply }
  it "should pass along reply to the bot" do
    class << self
      def from
        :foo
      end
    end
    msg = mock("msg")
    Jabber::Message.should_receive(:new).with(:foo,:bar).and_return(msg)
    bot.should_receive(:send).with(msg)
    bot.sreply(:baz)
  end
end