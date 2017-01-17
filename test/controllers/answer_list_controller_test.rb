require 'test_helper'

class AnswerListControllerTest < ActionController::TestCase
  test "should get :delete" do
    get ::delete
    assert_response :success
  end

end
