require 'test_helper'

class AwsAccounts::InstancesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
