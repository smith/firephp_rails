require 'test_helper'

class FirePHPController < ActionController::Base
  include FirePHP

  def a
    firephp("hi")
    render :nothing => true
  end


  def b
    fb("hi")
    render :nothing => true
  end
end

class FirePHPControllerTest < ActionController::TestCase
  EXAMPLE_HEADER = "X-Wf-Protocol-1"

  test "firephp method exists" do
    get :a
  end

  test "fb method exists" do
    get :b
  end

  test "headers not sent on non-firephp enabled request" do
    get :a
    assert !@response.headers.include?(EXAMPLE_HEADER)
  end

  test "headers sent on firephp enabled request" do
    @request.env["HTTP_USER_AGENT"] = "FirePHP/"
    get :a
    assert @response.headers.include?(EXAMPLE_HEADER)
  end

  test "headers not sent in production mode" do
    ENV["RAILS_ENV"] = "production"
    get :a
    assert !@response.headers.include?(EXAMPLE_HEADER)
    ENV["RAILS_ENV"] = "test"
  end

end
