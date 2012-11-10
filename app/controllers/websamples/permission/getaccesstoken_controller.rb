require 'cgi'
require 'profile'
require 'caller'
class Websamples::Permission::GetaccesstokenController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def begin
    reset_session
    redirect_to :action => 'get'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def get_token
    @@ep["SERVICE"]="/Permissions/GetAccessToken" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "token"=>params[:token]
           }
        if(params[:verifier] != "")
          req["verifier"]=params[:verifier]
        end

        if(params[:subjectAlias] !="")
          req["subjectAlias"]=params[:subjectAlias]
        end
  #Make the call to PayPal to Get access token on behalf of the caller If an error occured, show the resulting errors
            @transaction = @caller.call(req)

  if (@transaction.success?)
        session[:gettoken_response]=@transaction.response   
        @response = session[:gettoken_response]
        redirect_to :action => 'get_token_response'
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end

  def get_token_response
    @response = session[:gettoken_response]
    @ack = @response["responseEnvelope.ack"]
    @token = @response["token"]
    @tokenSecret = @response["tokenSecret"]
  end

end
