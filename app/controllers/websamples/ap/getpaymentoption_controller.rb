require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::GetpaymentoptionController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
    redirect_to :action => 'paymentOption'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
  
  def paymentOption
  end


def get_paymentOption
    @@ep["SERVICE"]="/AdaptivePayments/GetPaymentOptions" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    #sending the request string to call method where the paymentDetails API call is made
    @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey" =>params[:paykey]
    }
    )  
     if (@transaction.success?)
      session[:getpaymentOption_response]=@transaction.response 
      redirect_to :controller => 'getpaymentoption',:action => 'details'
    else
      session[:paypal_error]=@transaction.response 
      redirect_to :controller => 'calls', :action => 'error'
     end  
   end
   
  def details
	 @response = session[:getpaymentOption_response]
         @emailHeaderImageUrl =  @response["displayOptions.emailHeaderImageUrl"]
         @emailMarketingImageUrl =  @response["displayOptions.emailMarketingImageUrl"]
         @institutionId =  @response["initiatingEntity.institutionCustomer.institutionId"]
         @institutionCustomerId =  @response["initiatingEntity.institutionCustomer.institutionCustomerId"]
         @firstName =  @response["initiatingEntity.institutionCustomer.firstName"]
         @lastName =  @response["initiatingEntity.institutionCustomer.lastName"]
         @displayName =  @response["initiatingEntity.institutionCustomer.displayName"]
         @countryCode =  @response["initiatingEntity.institutionCustomer.countryCode"]
         @email =  @response["initiatingEntity.institutionCustomer.email"]
  end

end
