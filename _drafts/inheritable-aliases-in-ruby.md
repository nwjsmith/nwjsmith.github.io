---
layout: post
title: Inheritable aliases in Ruby
---
# Inheritable aliases in Ruby

When creating an abstract class in Ruby, it's _sometimes helpful_ to provide aliases to abstract methods. Unfortunately, `alias_method` behaves unexpectedly in this situation.

``` ruby
class Greeter
  def greeting
    fail NotImplementedError, "#greeting is not implemented"
  end
  alias_method :salutation, :greeting
end

class Employee < Greeter
  def greeting
    "Howdy"
  end
end

employee = Employee.new
employee.greeting # => "Howdy"
employee.salutation # => 
# ~> -:3:in `greeting': #greeting is not implemented (NotImplementedError)
# ~>  from -:16:in `<main>'
```

The alias to greeting created by the `alias_method` call in the superclass is pointing to the abstract `#greeting`, not the implementation in the subclass. One of the ways we can get around this is by using the `Forwardable` module provided in stdlib. `Forwardable` provides a method, `def_delegator`, that takes a target, the name of a method to delegate to, and an alias to delegate from.

``` ruby
require 'forwardable'

class Greeter
  extend Forwardable
  def greeting
    fail NotImplementedError, "#greeting is not implemented"
  end
  def_delegator :self, :greeting, :salutation
end

class Employee < Greeter
  def greeting
    "Howdy"
  end
end

employee = Employee.new
employee.greeting # => "Howdy"
employee.salutation # => "Howdy"
```

This works because `def_delegator` will define a method that delegates all calls to `#salutation` through to `self#greeting`. When calling `employee.salutation`, `self` is an instance of `Employee` and so the delegator calls `Employee#greeting` rather than the implementation in the superclass. The problem with `def_delegator` is that it's confusing for whomever comes across this code next. It isn't clear at all that we're using `def_delegator` to get around a limitation of `alias_method`. For that reason, I'd recommend creating our own `inheritable_alias` method that can be used in place of this.

``` ruby
module Aliases
  def inheritable_alias(new_method, original_method)
    define_method new_method do |*args, &block|
      public_send(original_method, *args, &block)
    end
  end
end
```

Now our code can look much cleaner.

``` ruby
class Greeter
  extend Aliases
  def greeting
    fail NotImplementedError, "#greeting is not implemented"
  end
  inheritable_alias :salutation, :greeting
end

class Employee < Greeter
  def greeting
    "Howdy"
  end
end

employee = Employee.new
employee.greeting # => "Howdy"
employee.salutation # => "Howdy"
```
