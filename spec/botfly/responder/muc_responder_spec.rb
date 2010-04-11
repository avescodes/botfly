require 'spec_helper'

include Botfly
describe Botfly::MUCResponder do
  subject { MUCResponder.new mock("muc", :bot => mock("bot")) }
end