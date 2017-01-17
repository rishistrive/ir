class AnswersController < ApplicationController

  before_action :set_answer, only: [:destroy, :update]

  def create
	  @answer = Answer.new(answer_params)
    @answer.display_order = 99 # TODO: fix this hardcoding - it's designed to force any newly created answers to the back of the list
	  if @answer.save
      if params[:answer_ids].present?
        @todo = ToDo.find(params[:to_do_id])
        params[:answer_ids].each_with_index do |id, index|
          answer = @todo.answers.find(id)
          answer.display_order = index
          answer.save
        end
      end
	  	render json: @answer.as_json
	  else
		render json: @answer.errors
	  end
  end

  def destroy
    @answer.destroy
    head :no_content
  end

  def update
    #@answer.selected = params[:selected]
    if @answer.update_attributes(answer_params)
      #head :no_content
      render json: @answer.as_json(include: :rules)
    else
      render json: @answer.errors
    end
  end

  def index
  end

  private

    def answer_params
      params.permit(:id, :to_do_id, :answer_ids, :content, :selected, :display_order)
    end

    def set_answer
      # TODO: make sure an inspector can only update their own
      @answer = Answer.find(params[:id])
    end
end
