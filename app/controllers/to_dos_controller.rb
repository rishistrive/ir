class ToDosController < ApplicationController

  before_action :set_to_do, only: [:update, :update_answer_order, :destroy]
  
  def create
	  @toDo = ToDo.new(to_do_params)
    @toDo.to_do_type = ToDoType.find(params[:to_do_type_id])
    @toDo.display_order = 99 # TODO: fix this hardcoding - it's designed to force any newly created to-dos to the back of the list

	  if @toDo.save
      if params[:todo_ids].present?
        @section = Section.find(params[:section_id])
        params[:todo_ids].each_with_index do |id, index|
          todo = @section.to_dos.find(id)
          todo.display_order = index
          todo.save
        end
      end
	  	render :json => @toDo.to_json(:include => { :to_do_type => { :only => :name } }, :only => [ :id, :content, :to_do_type_id ] )
	  else
      render json: @toDo.errors
	  end
  end

  def destroy
    @to_do.destroy
    head :no_content
  end

  def update_answer_order
    params[:answer_ids].each_with_index do |id, index|
      answer = @to_do.answers.find(id)
      answer.display_order = index
      answer.save
    end
    head :ok
  end

  def update

  end

  def index
  end

private

  def to_do_params
    params.permit(:id, :content, :section_id, :todo_ids, :to_do_type_id, :completed, :display_order, :answer_ids)
  end

  def set_to_do
    # TODO: should only be possible to set the todo to a todo available to the inspector
    @to_do = ToDo.find(params[:id])
  end
end
