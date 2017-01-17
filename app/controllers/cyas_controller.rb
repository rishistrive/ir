class CyasController < ApplicationController

  protect_from_forgery :except => [:create, :destroy, :update] # TODO: I don't think this is a secure approach

  before_action :set_cya, only: [:update, :destroy]

  def create
	  @cya = Cya.new(cya_params)
	  if @cya.save
	  	render json: @cya.as_json
	  else
      render json: @cya.errors
	  end
  end

  def destroy
    @cya.destroy
    head :no_content
  end

  def update
    if @cya.update(cya_params)
      #render status: :ok
      head :ok
    else
      render json: @cya.errors
    end
  end

  def index
  end
  
  private

    def cya_params
      params.permit(:content, :section_id, :completed, :display_order)
    end

    # TODO: make sure it isn't possible to update / delete / create a cya on another inspector's stuff
    def set_cya
      @cya = Cya.find(params[:id])
    end
end
