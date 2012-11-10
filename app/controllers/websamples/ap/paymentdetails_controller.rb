
require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::PaymentdetailsController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
    redirect_to :action => 'getPaymentDetails',:paykey => params[:paykey]
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index'
  end

  def getPaymentDetails
	  @paykey=params[:paykey]
  end
def pay_details
     @@ep["SERVICE"]="/AdaptivePayments/PaymentDetails" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    #sending the request string to call method where the paymentDetails API call is made
    @transaction_paydetails = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey" =>params[:paykey]
    }
    )  
     if (@transaction_paydetails.success?)
      session[:paydetails_response]=@transaction_paydetails.response 
      redirect_to :controller => 'paymentdetails',:action => 'details'
    else
      session[:paypal_error]=@transaction_paydetails.response 
      redirect_to :controller => 'calls', :action => 'error'
     end 
end

  def details
    @response = session[:paydetails_response]
    @TransactionStatus =  @response["status"]
    @paykey =  @response["payKey"]
    @senderEmai =  @response["senderEmail"]
    @currencyCode =  @response["currencyCode"]
    @feesPayer =  @response["feesPayer"]
    @actionType =  @response["actionType"]
  end

end
