Spec::Matchers.define :assign do |ivar|
  match do |klass|
    check_assignment(klass,ivar)
  end
  description { "assign to the instance variable @#{ivar}" }
  def check_assignment(klass,ivar)
    klass.instance_variable_get("@#{ivar}") != nil
  end
end
