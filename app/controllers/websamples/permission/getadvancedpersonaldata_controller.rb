require 'cgi'
require 'profile'
require 'caller'
require 'logger'

class Websamples::Permission::GetadvancedpersonaldataController < ApplicationController

  @@profile = PayPalSDKProfiles::Profile
  @@ep=@@profile.endpoints
  @@clientDetails=@@profile.client_details
  @@redirectURL=@@profile.PAYPAL_Redirect_URL
  def begin
    reset_session
    redirect_to :action => 'get'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index'
    end

  def add
    @host=request.host.to_s
    @port=request.port.to_s
    @callback="http://#{@host}:#{@port}/websamples/permission/getadvancedpersonaldata/get_advanced_personal_data_response"
  end

  def get_advanced_personal_data
    @@ep["SERVICE"]="/Permissions/GetAdvancedPersonalData"
    @caller =  PayPalSDKCallers::Caller.new(false)

    req={
      "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
      "clientDetails.deviceId" =>@@clientDetails["deviceId"],
      "clientDetails.applicationId" => @@clientDetails["applicationId"],
      
    }
    
     
      
    if params[:attr]!=nil 
     
      for ctr in 0..params[:attr].length-1 do
     
       req["attributeList.attribute(#{ctr})"] = params[:attr][ctr]                              
       end
   end
                      
    #Make the call to PayPal to RequestPermissions on behalf of the caller If an error occured, show the resulting errors
    @transaction = @caller.call(req)

    if (@transaction.success?)
      session[:getAdvancedPersonalData_response]=@transaction.response
      @response = session[:getAdvancedPersonalData_response]
       redirect_to :action => 'get_advanced_personal_data_response'
         else
      session[:paypal_error]=@transaction.response
      redirect_to :controller => 'calls', :action => 'error'
    end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    end

  def get_advanced_personal_data_response
    @response = session[:getAdvancedPersonalData_response]
    
  end

end
