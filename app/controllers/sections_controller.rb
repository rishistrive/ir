class SectionsController < ApplicationController
  
  protect_from_forgery :except => [:index, :update]  
  
  before_action :find_inspector
  
  before_action :set_section, only: [:index, :update, :update_all, :update_all_images, :update_cya_order, :update_todo_order]
  
  def index
	  #TODO: maybe I should split this into two separate methods?  One for the sections within a section, and one for all the other stuff in a section (stmts, to-dos, cyas, images)?
		render :json => @section.to_json(:include => {
							:cyas => { :only => [ :content, :id, :display_order, :completed ] }, 
							:images => { :only => :caption },	      
							:to_dos => {
								:include => { 
									:answers => { 
										:include => { 
											:rules => { :only => [ :id, :inspector_statement_id ] } 
										},
										:only => [ :id, :content, :display_order, :selected ]	
									} 
								},
								:only => [ :id, :content, :to_do_type_id, :completed ]
							},
							:statements => { 
								:include => {
									:statement_type => { :only => :name }
								},
								:only => [ :id, :content, :statement_type_id ]
							}
						},
						:only => [:id, :inspected, :not_inspected, :not_present, :deficient]) 
  end

  def update
    if @section.update_attributes(section_params)
      head :ok
    else
      render json: @section.errors
    end
  end

  def update_all
    params[:statement_ids].each_with_index do |id, index|
      statement = @section.statements.find(id)
      statement.display_order = index
      statement.save
    end
    head :ok
  end

  def update_todo_order
    params[:todo_ids].each_with_index do |id, index|
      todo = @section.to_dos.find(id)
      todo.display_order = index
      todo.save
    end
    head :ok
  end
  
  def update_cya_order
    params[:cya_ids].each_with_index do |id, index|
      cya = @section.cyas.find(id)
      cya.display_order = index
      cya.save
    end
    head :ok
  end

  def update_all_images
    params[:image_ids].each_with_index do |id, index|
      image = @section.images.find(id)
      image.display_order = index
      image.save
    end
    head :ok
  end

  private
 
    def set_section
      @section = Section.find(params[:id])
    end
    
    def section_params
      params.permit(:report_id, :id, :image_id, :cya_ids, :todo_ids, :statement_ids, :inspected, :not_inspected, :not_present, :deficient, :inspector_statement_ids)
    end
end
