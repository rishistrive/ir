class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session #:exception
  
  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]  
  
  private
  
  def confirm_logged_in
    #puts "about to output session"
    #Rails.logger.info(session)
    #puts "done outputting session"
    #http_request_header_keys = request.headers.env.keys.select{|header_name| header_name.match("^HTTP_COOKIE")}
    #http_request_headers = request.headers.env.select{|header_name, header_value| http_request_header_keys.index(header_name)}
    
    #puts "HTTP_COOKIE is: "
    #Rails.logger.info(http_request_headers)
    #puts "end HTTP_COOKIE logging"
    
    #Rails.logger.info(session)
    #Rails.logger.info(cookies[:_ir_session])
    #Rails.logger.info("Session user_id: " + session[:user_id].to_s)
    #Rails.logger.info("Session email: " + session[:email].to_s)
    
    unless session[:user_id]
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'access', :action => 'login')
      return false # halts the before_action
    else
      return true
    end
  end
  
  def find_inspector
    @inspector = Inspector.find(session[:user_id])
  end
  
  def set_report
    @report = @inspector.reports.find(params[:id])
  end
  
end
