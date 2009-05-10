require 'test_helper'

class FirephpRailsTest < ActiveSupport::TestCase
  test "firephp method exists" do
    assert ActionController::Base.private_methods.include?("firephp")
  end

  test "fb method exists" do
    assert ActionController::Base.private_methods.include?("fb")
  end
end
