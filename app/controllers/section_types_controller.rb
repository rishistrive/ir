class SectionTypesController < ApplicationController

  protect_from_forgery 

  before_action :find_inspector

  before_action :set_section_type, only: [:update_inspector_statement_order]

  def index
    @sectionTypes = @inspector.section_types.all
    render :json => @sectionTypes.to_json(:only => [:name, :id, :level])
  end

  def update_inspector_statement_order
    params[:inspector_statement_ids].each_with_index do |id, index|
      inspector_statement = @section_type.inspector_statements.find(id)
      inspector_statement.display_order = index
      inspector_statement.save
    end
    head :ok
  end

  private
 
    def set_section_type
      @section_type = @inspector.section_types.find(params[:id])
    end
    
    def section_type_params
      params.permit(:id, :inspector_statement_ids)
    end
  
end
