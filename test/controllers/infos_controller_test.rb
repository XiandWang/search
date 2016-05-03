require 'test_helper'

class InfosControllerTest < ActionController::TestCase
  test "should get like" do
    get :like
    assert_response :success
  end

end
