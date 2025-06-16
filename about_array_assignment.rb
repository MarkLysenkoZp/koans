require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutArrayAssignment < Neo::Koan
  def test_non_parallel_assignment
    names = ["John", "Smith"]
    assert_equal ["John", "Smith"], names
  end

  def test_parallel_assignments
    first_name, last_name = ["Walter", "White"]
    assert_equal "Walter", first_name
    assert_equal "White", last_name
  end

  def test_parallel_assignments_with_extra_values
    first_name, last_name = ["Mark", "Lysenko", "III"]
    assert_equal "Mark", first_name
    assert_equal "Lysenko", last_name
    # "III" Ignored because there is no variable for it
  end

  def test_parallel_assignments_with_splat_operator
    first_name, *last_name = ["Gabe", "Newell", "III"]
    assert_equal "Gabe", first_name
    assert_equal ["Newell", "III"], last_name
  end

  def test_parallel_assignments_with_too_few_values
    first_name, last_name = ["Cher"]
    assert_equal "Cher", first_name
    assert_equal nil, last_name # For last_name there wasn't enough element
  end

  def test_parallel_assignments_with_subarrays
    first_name, last_name = [["Willie", "Rae"], "Johnson"]
    assert_equal ["Willie", "Rae"], first_name
    assert_equal "Johnson", last_name
  end

  def test_parallel_assignment_with_one_variable
    first_name, = ["John", "Smith"]
    assert_equal "John", first_name
  end

  def test_swapping_with_parallel_assignment
    first_name = "Roy"
    last_name = "Rob"
    first_name, last_name = last_name, first_name
    assert_equal "Rob", first_name
    assert_equal "Roy", last_name
  end
end
