class AnswerValuesController < ApplicationController
  before_action :find_inspector
  
  before_action :set_answer_value, only: [:destroy]

  def destroy
    # TODO: make sure it's not possible to destroy another inspector's answer value
    @answer_value.destroy
  end
  
  private
  
    def set_answer_value
      @answer_value = AnswerValue.find(params[:id])
      #TODO: add some kind of check here to be sure that the answer value belongs to the inspector who is logged in
    end
    
    
end
