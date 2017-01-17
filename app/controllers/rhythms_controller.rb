class RhythmsController < ApplicationController
  
  before_action :find_inspector
  
  def index
    # TODO: not sure if this is the best approach to use with my nested associations
    @rhythms = Rhythm.joins(inspection_template: :inspector).where("inspector_id = ?", @inspector.id)
    #@templates = @inspector.templates.rhythms.order("name")
    #@rhythms = @templates.each
  end

  def show
	@rhythm = Rhythm.find(params[:id])

    respond_to do |format|
      format.json {
        render :json => @rhythm.to_json(:include => {
                        :rhythm_sections => { :include => {
                        :section_type => { :only => :name }
                        }
                      }
                  })
      }
    end
  end

  private
  
  def rhythm_params
	  params.permit(:id)
  end
end
