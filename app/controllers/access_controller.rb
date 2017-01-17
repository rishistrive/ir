class AccessController < ApplicationController
  
  protect_from_forgery :except => :attempt_login
  
  def index
    # display text and links
  end

  def login
    
  end
  
  def attempt_login
    
    #Rails.logger.info(request.env)
    puts params[:password]
    puts params[:email]
    if params[:email].present? && params[:password].present?
      found_user = Inspector.where(:email => params[:email]).first
      
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
    end
    if authorized_user
    
      session[:user_id] = authorized_user.id
      session[:email] = authorized_user.email
      
      respond_to do |format|
        format.json {
          #response.header['X-CSRF-Token'] = form_authenticity_token
          #render "attempt_login.js.erb"
          head :ok
        }
        format.html {
          redirect_to(:controller => 'inspectors', :action => 'show')
        }
        
      end
      
    else
      puts "unauthorized"
      respond_to do |format|
        
        format.json {
          head :unauthorized
        }
        format.html {
          redirect_to(:action => 'login')
        }
      end
    end
  end
  
  def logout
    session[:user_id] = nil
    session[:email] = nil
    redirect_to(:action => 'login')
  end
  
  
  
end
