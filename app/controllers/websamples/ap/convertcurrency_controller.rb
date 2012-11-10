require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::ConvertcurrencyController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def begin
  reset_session
    render :action => 'setConvertCurrency'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
   
  def setConvertCurrency
  end
  
  def convert_currency
  @@ep["SERVICE"]="/AdaptivePayments/ConvertCurrency" 
  @caller =  PayPalSDKCallers::Caller.new(false)
    
    #sending the request string to call method where the PAY API call is made
    @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
      "clientDetails.deviceId" =>@@clientDetails["deviceId"],
      "clientDetails.applicationId" => @@clientDetails["applicationId"],
      "baseAmountList.currency(0).amount"=>params[:baseAmmount_0],
      "baseAmountList.currency(0).code"=>params[:baseCurrency_0],
      "baseAmountList.currency(1).amount"=>params[:baseAmmount_1],
      "baseAmountList.currency(1).code"=>params[:baseCurrency_1],
      "convertToCurrencyList.currencyCode(0)"=>params[:toCode_0],
      "convertToCurrencyList.currencyCode(1)" =>params[:toCode_1],
      "convertToCurrencyList.currencyCode(2)"=>params[:toCode_2]
      }
    )       
    
     if (@transaction.success?)
        session[:paydetails_response]=@transaction.response   
        redirect_to :controller => 'convertcurrency',:action => 'details'
    else
          session[:paypal_error]=@transaction.response 
          redirect_to :controller => 'calls', :action => 'error'
    end
  end

  def details
	  @response = session[:paydetails_response]
  end

end
