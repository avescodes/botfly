$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'botfly'
require 'spec'
require 'spec/autorun'
require 'support/jabber'
require 'support/custom_matchers'

Spec::Runner.configure do |config|
  Botfly.logger.level = Logger::FATAL
end

class Object
  def assigns(name)
    instance_variable_get("@#{name}")
  end
end
