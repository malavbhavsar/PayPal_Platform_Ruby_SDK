require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::CancelpreapprovalController < ApplicationController
	  
  @@profile = PayPalSDKProfiles::Profile
  @@ep=@@profile.endpoints
  @@clientDetails=@@profile.client_details
  
  def cancelPreapproval
    reset_session
  end

  def cancel
    @@ep["SERVICE"]="/AdaptivePayments/CancelPreapproval" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    #sending the request string to call method where the paymentDetails API call is made
    @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "preapprovalKey" => params[:preapprovalkey]
    }
    )  
     if (@transaction.success?)
      session[:cancelPreapproval_response]=@transaction.response 
      redirect_to :controller => 'cancelpreapproval',:action => 'details'
    else
      session[:paypal_error]=@transaction.response 
      redirect_to :controller => 'calls', :action => 'error'
     end  
   end 
   
  def details
    @response = session[:cancelPreapproval_response]
    @transactionStatus= @response["responseEnvelope.ack"]
    @correlationId = @response["responseEnvelope.correlationId"]
  end

end
