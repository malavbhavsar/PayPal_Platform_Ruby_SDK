require 'cgi'
require 'profile'
require 'caller'

class Websamples::Permission::RequestpermissionsController < ApplicationController

  @@profile = PayPalSDKProfiles::Profile
  @@ep=@@profile.endpoints
  @@clientDetails=@@profile.client_details
  @@redirectURL=@@profile.PAYPAL_Redirect_URL
  def begin
    reset_session
    redirect_to :action => 'add',:callback =>params[:callback]
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index'
    end

  def add
    @host=request.host.to_s
    @port=request.port.to_s
    @callback="http://#{@host}:#{@port}/websamples/permission/requestpermissions/request_permissions_response"
  end

  def request_permissions
    @@ep["SERVICE"]="/Permissions/RequestPermissions"
    @caller =  PayPalSDKCallers::Caller.new(false)

    req={
      "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
      "clientDetails.deviceId" =>@@clientDetails["deviceId"],
      "clientDetails.applicationId" => @@clientDetails["applicationId"],
      "callback"=>params[:callback]
    }
    
    
    if params[:scope]!=nil 
      for ctr in 0..params[:scope].length-1 do
       req["scope(#{ctr})"] = params[:scope][ctr]                              
       end
   end
                      
    #Make the call to PayPal to RequestPermissions on behalf of the caller If an error occured, show the resulting errors
    @transaction = @caller.call(req)

    if (@transaction.success?)
      session[:reqPermission_response]=@transaction.response
      @response = session[:reqPermission_response]
      @token = @response["token"]
      redirect_to @@redirectURL+"_grant-permission&request_token=#{@token}"
    else
      session[:paypal_error]=@transaction.response
      redirect_to :controller => 'calls', :action => 'error'
    end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    end

  def request_permissions_response
    @response = session[:reqPermission_response]
    @ack = @response["responseEnvelope.ack"]
    @token = @response["token"]
    @verification = request.query_parameters["verification_code"]
  end

end
