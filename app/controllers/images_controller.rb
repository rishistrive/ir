class ImagesController < ApplicationController

  protect_from_forgery :except => [:create, :destroy]

  def create
    @image = Image.new(image_params)
    @image.display_order = 99
    if @image.save
      if params[:image_ids].present?
        @section = Section.find(params[:section_id])
        params[:image_ids].each_with_index do |id, index|
          image = @section.images.find(id)
          image.display_order = index
          image.save
        end
      end
      render :json => @image.to_json(:methods => [:image_url, :image_thumbnail_url]) 
    else
      puts "image save failed"
    end
  end
  
  def update
    @image = Image.find(params[:id])
    if @image.update(image_params)
      render {}
    else
      puts "image save failed"
    end
  end
  
  def destroy
    Image.find(params[:id]).destroy
  end
  
  private
    # TODO - make sure it isn't possible to destroy another inspectors images
    def image_params
      #params.require(:images).permit(:caption, :display_order, :photo, :section_type_id)
      params.permit(:caption, :display_order, :image, :section_id, :image_ids)
    end
end
