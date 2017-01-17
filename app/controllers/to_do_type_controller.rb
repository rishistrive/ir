class ToDoTypeController < ApplicationController
  def create
	@toDoType = ToDoType.new(to_do_type_params)
	if @toDoType.save 
		render json: @toDoType.as_json
	else
		render json: @toDoType.errors
	end
  end

  def index
  end

private

  def to_do_type_params
	params.permit(:name)
  end

end
