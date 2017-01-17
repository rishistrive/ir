class InspectorStatementsController < ApplicationController
  
  before_action :find_inspector
  
  before_action :set_statement, only: [:update, :destroy]
  
  def index
    
    if (params.has_key?(:search))
      # TODO: search by section type name
      @inspectorStatements = @inspector.inspector_statements.where(section_type_id: params[:section_type_id]).where("lower(keyword) like lower(?) or lower(content) like lower(?)", '%' + params[:search] + '%', '%' + params[:search] + '%')
      
      # TODO: dry this up
      respond_to do |format|
        # TODO: use :only to pass back the bare minimum
        format.json {render json: @inspectorStatements.to_json(:include => [:statement_type, :section_type])}
        format.html 
      end
      
    else
    
      if (params.has_key?(:section_type_id))
        # TODO: protect params
        #@inspectorStatements = @inspector.inspector_statements.joins(:statement_type).where(section_type_id: params[:section_type_id])
        @inspectorStatements = @inspector.inspector_statements.where(section_type_id: params[:section_type_id])
        respond_to do |format|
          format.json {render json: @inspectorStatements.to_json(:include => :statement_type)}
          format.html 
        end
      else
        @inspectorStatements = @inspector.inspector_statements.all
        respond_to do |format|
          # TODO: why do I need to include statement_types here.  It's causing a lot of repeated cache hits on the server.
          format.json {render json: @inspectorStatements.to_json(:include => :statement_type)}
          format.html 
        end
      end
    end
  end
  
  def new
    @inspectorStatement = InspectorStatement.new(inspector_id: @inspector.id);
  end

  def create
    @inspectorStatement = InspectorStatement.new(inspector_statement_params)
    @inspectorStatement.inspector_id = @inspector.id
    @inspectorStatement.display_order = 999 # TODO: fix this hardcoding - it's designed to force any newly created inspector statements to the back of the list
    if @inspectorStatement.save
      if params[:inspector_statement_ids].present?
        params[:inspector_statement_ids].each_with_index do |id, index|
          inspector_statement = @inspector.inspector_statements.find(id)
          inspector_statement.display_order = index
          inspector_statement.save
        end
      end
      render json: @inspectorStatement.as_json(only: [:id, :content, :keyword, :statement_type_id])
    else
      render :new
    end
  end

  def update
    if @inspectorStatement.update(inspector_statement_params)
    #if @inspectorStatement.update(content: params[:content],
                                  #keyword: params[:keyword],
                                  #section_type_id: params[:section_type_id],
                                  #statement_type_id: params[:statement_type_id])#, #commented following line b/c to-dos usurped list_types and the old answer_values model
                                  #list_type: params[:list_type])
      head :ok
    else
      render json: @inspectorStatement.errors
    end
  end
=begin
       if params.has_key?(:answer_values)
        
        params[:answer_values].each do |key, value|
        
          if value[:id]
            answerValue = AnswerValue.find(value[:id])
            #TODO: fix display order
            answerValue.update(value: value[:value]) #, display_order: index)
          else
            answerValue = AnswerValue.new(inspector_statement_id: @inspectorStatement.id, value: value[:value]) # , display_order: index)
            answerValue.save
          end
        
        end
        
      end
      
      render json: @inspectorStatement
    else
      render json: @inspectorStatement.errors
    end
  end
=end

  def delete
    destroy
  end
  
  def destroy
    # TODO: make sure it's not possible to destroy another inspector's statement
    @inspectorStatement.destroy
  end

  def copy_library
    @recipientInspector = Inspector.find(params[:recipient_inspector_id])
    @inspectorStatements = @inspector.inspector_statements;

    @inspectorStatements.each do |statement|
      # first, check to see if this statement already exists in the recipient's library
      if @recipientInspector.inspector_statements.exists?(content: statement.content)
        # statement exists in recipient's library already, so do nothing
        #puts statement.id.to_s + ' already exists for recipient inspector'
      else
        # statement doesn't exist in recipient's library, so create it
        newStatement = InspectorStatement.new(inspector_id: params[:recipient_inspector_id], section_type_id: statement.section_type.get_matching_section_type_id(statement.section_type.id, @recipientInspector.id), content: statement.content, statement_type_id: statement.statement_type_id, keyword: statement.keyword)
        newStatement.save
      end
    end
  end
  
  private
  
    def set_statement
      @inspectorStatement = @inspector.inspector_statements.find(params[:id])
    end
    
    def inspector_statement_params
      #params.require(:inspector_statement).permit(:content, :keyword, :section_type_id, :statement_type_id, :list_type, {answer_values: [:value]})
      params.permit(:search, :content, :keyword, :section_type_id, :statement_type_id, :list_type, :inspector_statement_ids, :recipient_inspector_id)
    end
    
end
