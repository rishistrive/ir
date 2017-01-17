class InspectorsController < ApplicationController
  def index
    #TODO: maybe admin view logic goes here?
    @inspector = Inspector.find(session[:user_id])
    render(:show)
    
  end
  
  def show
    # TODO: revisit this if I want to figure out how to keep csrf checking
    #response.header['X-CSRF-Token'] = form_authenticity_token
    @inspector = Inspector.find(session[:user_id])    
  end

  def edit
  end
end
