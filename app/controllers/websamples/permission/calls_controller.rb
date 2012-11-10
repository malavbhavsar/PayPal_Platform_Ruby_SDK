class Websamples::Permission::CallsController < ApplicationController
  def index  
  end  
  
  def error 
   @response = session[:paypal_error]
   @ack_status= @response["ACK"]
	 @errorcode = @response["L_ERRORCODE0"]
	 @shortmessage = @response["L_SHORTMESSAGE0"]
	 #TODO: get all messages and concat it
	 @longmessage = @response["L_LONGMESSAGE0"]
  end 
  
  def exception
    @longmessage = flash[:error]
    p @longmessage
  end
end
