require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::SetfundingsourceconfirmedController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
    redirect_to :action => 'set'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def set
  end


def set_funding_source_confirmed
    @@ep["SERVICE"]="/AdaptiveAccounts/SetFundingSourceConfirmed" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "fundingSourceKey"=>params[:fundingSourceKey],
             "emailAddress"=>params[:email]
           }
  #Make the call to PayPal to Add Bank Account on behalf of the caller If an error occured, show the resulting errors
            @transaction = @caller.call(req)
    if (@transaction.success?)
        session[:fundingSource_response]=@transaction.response   
        redirect_to :controller => 'setfundingsourceconfirmed',:action => 'funding_source_details'
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end
  
  def funding_source_details
    @response = session[:fundingSource_response]
    @Status =  @response["responseEnvelope.ack"]
    @timestamp =  @response["responseEnvelope.timestamp"]
    @correlationId =  @response["responseEnvelope.correlationId"]
    @build =  @response["responseEnvelope.build"]
  end

end
