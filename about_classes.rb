# Load the Neo koans test framework
require File.expand_path(File.dirname(__FILE__) + '/neo')

# Define a test class that inherits from Neo::Koan
class AboutClasses < Neo::Koan

  # Simple class with no methods or variables
  class Dog
  end

  def test_instances_of_classes_can_be_created_with_new
    fido = Dog.new
    # Every object in Ruby knows its class
    assert_equal AboutClasses::Dog, fido.class
  end

  # Class with an instance variable
  class Dog2
    def set_name(a_name)
      @name = a_name  # @name is an instance variable; it belongs to the specific object
    end
  end

  def test_instance_variables_are_set_by_instance_methods
    fido = Dog2.new
    # Object has no instance variables at first
    assert_equal [], fido.instance_variables

    fido.set_name("Fido")
    # Now it has one: @name
    assert_equal [:@name], fido.instance_variables
  end

  def test_instance_variables_cannot_be_accessed_outside_the_class
    fido = Dog2.new
    fido.set_name("Fido")

    # There's no method called `name`, so this raises an error
    assert_raise(NoMethodError) do
      fido.name
    end

    # Trying to use fido.@name is a syntax error
    assert_raise(SyntaxError) do
      eval "fido.@name"
    end
  end

  def test_you_can_politely_ask_for_instance_variable_values
    fido = Dog2.new
    fido.set_name("Fido")

    # You can access instance variables using reflection (not common practice)
    assert_equal "Fido", fido.instance_variable_get("@name")
  end

  def test_you_can_rip_the_value_out_using_instance_eval
    fido = Dog2.new
    fido.set_name("Fido")

    # instance_eval allows you to run code in the context of the object
    assert_equal "Fido", fido.instance_eval("@name")
    assert_equal "Fido", fido.instance_eval { @name }
  end

  # Add a method to read the instance variable
  class Dog3
    def set_name(a_name)
      @name = a_name
    end

    def name
      @name
    end
  end

  def test_you_can_create_accessor_methods_to_return_instance_variables
    fido = Dog3.new
    fido.set_name("Fido")

    # Now we can read the @name using the name method
    assert_equal "Fido", fido.name
  end

  # Use attr_reader to automatically create a getter method
  class Dog4
    attr_reader :name  # Creates a method that returns @name

    def set_name(a_name)
      @name = a_name
    end
  end

  def test_attr_reader_will_automatically_define_an_accessor
    fido = Dog4.new
    fido.set_name("Fido")

    # Same result, less code
    assert_equal "Fido", fido.name
  end

  # Use attr_accessor to create both getter and setter
  class Dog5
    attr_accessor :name  # Creates both name and name= methods
  end

  def test_attr_accessor_will_automatically_define_both_read_and_write_accessors
    fido = Dog5.new
    fido.name = "Fido"  # Setter method (name=)
    assert_equal "Fido", fido.name  # Getter method (name)
  end

  # Constructor method using `initialize`
  class Dog6
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name  # Called automatically when .new is used
    end
  end

  def test_initialize_provides_initial_values
    fido = Dog6.new("Fido")
    assert_equal "Fido", fido.name
  end

  def test_args_to_new_must_match_initialize
    # Calling new without an argument causes an error
    assert_raise(ArgumentError) do
      Dog6.new
    end
  end

  def test_different_objects_have_different_instance_variables
    fido = Dog6.new("Fido")
    rover = Dog6.new("Rover")

    # Each object stores its own @name
    assert_equal true, rover.name != fido.name
  end

  # Exploring `self`, `to_s`, and `inspect`
  class Dog7
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name
    end

    def get_self
      self  # self refers to the current object
    end

    def to_s
      @name  # to_s defines how the object looks as a string
    end

    def inspect
      "<Dog named '#{name}'>"  # inspect is used in debugging (irb, etc.)
    end
  end

  def test_inside_a_method_self_refers_to_the_containing_object
    fido = Dog7.new("Fido")
    fidos_self = fido.get_self
    assert_equal fido, fidos_self  # They are the same object
  end

  def test_to_s_returns_a_string_representation
    fido = Dog7.new("Fido")
    assert_equal "Fido", fido.to_s
  end

  def test_string_interpolation_uses_to_s
    fido = Dog7.new("Fido")
    assert_equal "My dog is Fido", "My dog is #{fido}"
  end

  def test_inspect_returns_a_debug_string
    fido = Dog7.new("Fido")
    assert_equal "<Dog named 'Fido'>", fido.inspect
  end

  def test_all_objects_support_to_s
    array = [1, 2, 3]
    assert_equal "[1, 2, 3]", array.to_s
    assert_equal "[1, 2, 3]", array.inspect

    string = "STRING"
    assert_equal "STRING", string.to_s
    assert_equal "\"STRING\"", string.inspect
  end
end
