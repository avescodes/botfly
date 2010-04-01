def stub_jabber_client
  client = stub("Jabber::Client",  :connect => nil, 
                                    :auth => nil,
                                    :send => nil)
  def client.method_missing(*args); end
  Jabber::Client.stub(:new).and_return(client)
  client
end
