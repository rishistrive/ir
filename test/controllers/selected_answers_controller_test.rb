require 'test_helper'

class SelectedAnswersControllerTest < ActionController::TestCase
  setup do
    @selected_answer = selected_answers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:selected_answers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create selected_answer" do
    assert_difference('SelectedAnswer.count') do
      post :create, selected_answer: { answer_value_id: @selected_answer.answer_value_id, statement_id: @selected_answer.statement_id }
    end

    assert_redirected_to selected_answer_path(assigns(:selected_answer))
  end

  test "should show selected_answer" do
    get :show, id: @selected_answer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @selected_answer
    assert_response :success
  end

  test "should update selected_answer" do
    patch :update, id: @selected_answer, selected_answer: { answer_value_id: @selected_answer.answer_value_id, statement_id: @selected_answer.statement_id }
    assert_redirected_to selected_answer_path(assigns(:selected_answer))
  end

  test "should destroy selected_answer" do
    assert_difference('SelectedAnswer.count', -1) do
      delete :destroy, id: @selected_answer
    end

    assert_redirected_to selected_answers_path
  end
end
