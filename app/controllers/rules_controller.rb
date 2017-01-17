class RulesController < ApplicationController

  before_action :set_rule, only: [:destroy, :update]

  def create
	  @rule = Rule.new(rules_params)
	  if @rule.save
	  	render json: @rule.as_json
	  else
		render json: @rule.errors
	  end
  end

  def destroy
  end

  def update
    if @rule.update_attributes(rules_params)
      head :no_content
    else
      render json: @rule.errors
    end
  end

  def index
  end

  private

  def rules_params
	  params.permit(:answer_id, :inspector_statement_id, :id)
  end

  def set_rule
    # TODO: make sure an inspector can only update their own
    @rule = Rule.find(params[:id])
  end

end
