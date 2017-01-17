class InspectionTemplatesController < ApplicationController
  
  before_action :find_inspector
  before_action :set_inspection_template, only: [:update, :copy, :destroy, :copy_to_another_inspector]
  
  def index
    @templates = @inspector.inspection_templates
    respond_to do |format|
      format.json {
        render :json => @templates.to_json(:include => [:report_type])
      }
      format.html{
      }
    end
  end
  
  def update
    if @inspectionTemplate.update(inspection_template_params)
      head :ok
    else
      render json: @inspectionTemplate.errors
    end
  end

  def show
    #@template = @inspector.inspection_templates.includes(sections: [{statements: :statement_type}, :section_type, {to_dos: {answers: { rules: :inspector_statement } } }, :cyas]).find(params[:id])
    @template = @inspector.inspection_templates.includes(sections: [{statements: :statement_type}, {section_type: :inspector_statements}, {to_dos: {answers:  :inspector_statements } }, :cyas]).find(params[:id])
    @statement_types = StatementType.all
    @todo_types = ToDoType.all
  end

  def destroy
    @inspectionTemplate.destroy
    head :ok
  end

  def copy
    @newTemplate = InspectionTemplate.new()
    @newTemplate.inspector_id = @inspectionTemplate.inspector_id
    # TODO: remove hardcoding of template name
    #@template.name = params[:name]
    @newTemplate.name = "I'm a new template" #params[:name]
    @newTemplate.report_type_id = @inspectionTemplate.report_type_id
    if @newTemplate.save
      level_0_section_id = nil
      level_1_section_id = nil
      @inspectionTemplate.sections.sorted.each do |section|
        if section.level == 0
          parent_section_id = nil
        end
        if section.level == 1
          parent_section_id = level_0_section_id
        end
        if section.level == 2
          parent_section_id = level_1_section_id
        end
        new_section = Section.new(inspection_template_id: @newTemplate.id, display_order: section.display_order, level: section.level, section_type_id: section.section_type_id, parent_section_id: parent_section_id)
        if new_section.save
          if section.level == 0
            level_0_section_id = new_section.id
          end
          if section.level == 1
            level_1_section_id = new_section.id
          end
          # create to-dos, answers and rules
          section.to_dos.each do |to_do|
            new_to_do = ToDo.new(content: to_do.content, display_order: to_do.display_order, section_id: new_section.id, to_do_type_id: to_do.to_do_type_id, completed: to_do.completed)
            if new_to_do.save
              # create answers
              to_do.answers.each do |answer|
                new_answer = Answer.new(to_do_id: new_to_do.id, content: answer.content, display_order: answer.display_order, selected: answer.selected)
                if new_answer.save
                  # create rules
                  answer.rules.each do |rule|
                    new_rule = Rule.new(answer_id: new_answer.id, inspector_statement_id: rule.inspector_statement_id)
                    new_rule.save
                  end
                end
              end
            end
          end
          # create cyas
          section.cyas.each do |cya|
            new_cya = Cya.new(content: cya.content, display_order: cya.display_order, section_id: new_section.id, completed: cya.completed)
            new_cya.save
          end
          # create statements
          section.statements.each do |statement|
            new_statement = Statement.new(content: statement.content, display_order: statement.display_order, section_id: new_section.id, statement_type_id: statement.statement_type_id)
            if new_statement.save
              # Iono...seems like something would go here
            end
          end
        end
      end
      @template = @newTemplate #TODO: i'm concerned about the memory implications of this.  would be safer, I think, to just use "@template" as the variable name.
      @statement_types = StatementType.all
      @todo_types = ToDoType.all
      render :show
    end
  end

  def copy_to_another_inspector
    @recipientInspectorId = params[:recipient_inspector_id]
    @newTemplate = InspectionTemplate.new()
    @newTemplate.inspector_id = @recipientInspectorId 
    # TODO: remove hardcoding of template name
    #@template.name = params[:name]
    @newTemplate.name = "I'm a new template, and I came from Andy" #params[:name]
    @newTemplate.report_type_id = @inspectionTemplate.report_type_id
    if @newTemplate.save
      #level_0_section_id = nil
      #level_1_section_id = nil
      @inspectionTemplate.sections.sorted.each do |section|
        new_section_type_id = nil
        new_parent_section_type_id = nil
        #if section.level == 0
          #parent_section_id = nil
        #end
        #if section.level == 1
          #parent_section_id = level_0_section_id
        #end
        #if section.level == 2
          #parent_section_id = level_1_section_id
        #end
        new_section_type_id = section.section_type.get_matching_section_type_id(section.section_type.id, @recipientInspectorId)
        if !section.parent_section_id.blank?
          new_parent_section_type_id = SectionType.find(section.parent_section.section_type_id).get_matching_section_type_id(section.parent_section.section_type_id, @recipientInspectorId)
        end
        new_section = Section.new(inspection_template_id: @newTemplate.id, display_order: section.display_order, level: section.level, section_type_id: new_section_type_id, parent_section_id: new_parent_section_type_id)
        if new_section.save
          #if section.level == 0
           #level_0_section_id = new_section.id
          #end
          #if section.level == 1
            #level_1_section_id = new_section.id
          #end
          # create to-dos, answers and rules
=begin
          section.to_dos.each do |to_do|
            new_to_do = ToDo.new(content: to_do.content, display_order: to_do.display_order, section_id: new_section.id, to_do_type_id: to_do.to_do_type_id, completed: to_do.completed)
            if new_to_do.save
              # create answers
              to_do.answers.each do |answer|
                new_answer = Answer.new(to_do_id: new_to_do.id, content: answer.content, display_order: answer.display_order, selected: answer.selected)
                if new_answer.save
                  # create rules
                  answer.rules.each do |rule|
                    if rule.inspector_statement_id != 0 
                      @newInspectorStatementId = InspectorStatement.find(rule.inspector_statement_id).get_matching_inspector_statement_id(@recipientInspectorId)
                    else
                      @newInspectorStatementId = nil
                    end
                    new_rule = Rule.new(answer_id: new_answer.id, inspector_statement_id: @newInspectorStatementId)
                    new_rule.save
                  end
                end
              end
            end
          end
=end
          # create cyas
          #section.cyas.each do |cya|
            #new_cya = Cya.new(content: cya.content, display_order: cya.display_order, section_id: new_section.id, completed: cya.completed)
            #new_cya.save
          #end
          # create statements
          section.statements.each do |statement|
            new_statement = Statement.new(content: statement.content, display_order: statement.display_order, section_id: new_section.id, statement_type_id: statement.statement_type_id)
            new_statement.save
          end
        end
      end
      @template = @newTemplate #TODO: i'm concerned about the memory implications of this.  would be safer, I think, to just use "@template" as the variable name.
      @statement_types = StatementType.all
      @todo_types = ToDoType.all
      render :show
    end
  end

  private

    def set_inspection_template
      @inspectionTemplate = @inspector.inspection_templates.find(params[:id])
    end
    
    def inspection_template_params
      params.permit(:id, :name, :recipient_inspector_id)
    end
  
end
