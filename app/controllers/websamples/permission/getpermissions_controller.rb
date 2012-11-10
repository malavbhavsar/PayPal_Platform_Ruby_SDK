require 'cgi'
require 'profile'
require 'caller'
class Websamples::Permission::GetpermissionsController < ApplicationController
	
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

  def get_permissions
   @@ep["SERVICE"]="/Permissions/GetPermissions" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "token"=>params[:token]
           }
  #Make the call to PayPal to Getpermission on behalf of the caller If an error occured, show the resulting errors
            @transaction = @caller.call(req)

  if (@transaction.success?)
        session[:getpermission_response]=@transaction.response   
        @response = session[:getpermission_response]
        redirect_to :action => 'get_permission_response'
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end

  def get_permission_response
	  @response = session[:getpermission_response]
  end

end
