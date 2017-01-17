class StatementsController < ApplicationController

  protect_from_forgery :except => [:create, :destroy, :update] # TODO: I don't think this is a secure approach

  before_action :find_inspector

  before_action :set_statement, only: [:update, :destroy]

  def index

    statement_params  # TODO: is this needed?

#    @report = Report.find(params[:report_id])
    @section = Section.find(params[:section_id])
    @statements = @section.statements.sorted  # TODO: sort by statement type first

    #Rails.logger.debug( @statements.to_yaml )

    render json: @statements.as_json(
      only: [:id, :updated_at, :inspector_statement_id, :display_order, :content],
      include: { statement_type: { only: [ :name ] } }
    )


  end

  def create
    @statement = Statement.new(statement_params)
    @statement.display_order = 999  #TODO: fix this hardcoded effort to force new statements to the end of the list
    if @statement.save
      if params[:statement_ids].present?
        @section = Section.find(params[:section_id])
        params[:statement_ids].each_with_index do |id, index|
          statement = @section.statements.find(id)
          statement.display_order = index
          statement.save
        end
      end
      render json: @statement.as_json(only: [ :id ])
    else
      render json: @statement.errors
    end
  end


  def update
    if @statement.update(statement_params)
      #render status: :ok
      head :ok
    else
      render json: @statement.errors
    end
  end


  def delete
    destroy
  end

  def destroy
    # TODO: make sure it's not possible to destroy another inspector's statement
    @statement.destroy
  end

  private

    # TODO: make sure it isn't possible to update / delete / create a statement on another inspector's stuff
    def set_statement
      @statement = Statement.find(params[:id])
    end

    def statement_params
      #params[:content]
      params.permit(:content, :id, :statement_type_id, :section_id, :report_id, :statement_ids)
    end

end
