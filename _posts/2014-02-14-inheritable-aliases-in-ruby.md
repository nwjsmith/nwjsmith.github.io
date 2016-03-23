---
layout: post
title: Inheritable aliases in Ruby
---
# Inheritable aliases in Ruby

Ruby's method aliases are pretty handy. So is inheritance. It's too bad that the two don't work well together:

{% highlight ruby %}
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
{% endhighlight %}

[Wat](https://www.destroyallsoftware.com/talks/wat)? Turns out that `alias_method` creates an alias that references the original method rather than the overwritten one. Fortunately, the Ruby standard library provides a workaround. By using the [`Forwardable`](http://www.ruby-doc.org/stdlib-2.1.0/libdoc/forwardable/rdoc/Forwardable.html) module and its [`def_delegator` method](http://www.ruby-doc.org/stdlib-2.1.0/libdoc/forwardable/rdoc/Forwardable.html#method-i-def_delegator), we can declare a delegator that forwards any call on to the overwritten method.

{% highlight ruby %}
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
{% endhighlight %}

Cool, now we have the alias working with inheritance. The only problem with this approach is maintainence. Let's make it clear why we're using something other than `alias_method` by defining our own inheritable version.

{% highlight ruby %}
module Aliases
  def inheritable_alias(new_method, original_method)
    define_method new_method do |*args, &block|
      public_send(original_method, *args, &block)
    end
  end
end
{% endhighlight %}

Now we can clean our code up.

{% highlight ruby %}
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
{% endhighlight %}

Now there's clarity around why we're not using `alias_method`. You can tell just by reading the method name. Rad.
