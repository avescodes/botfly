$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'botfly'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  Botfly.logger.level = Logger::FATAL
end

def stub_jabber_client
  @client = stub("Client", :connect => nil, 
                           :auth => nil,
                           :send => nil)
  def @client.method_missing(*args); end
  Jabber::Client.should_receive(:new).and_return(@client)
end
