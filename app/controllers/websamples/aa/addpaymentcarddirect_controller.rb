require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::AddpaymentcarddirectController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def begin
  reset_session
    redirect_to :action => 'add_card'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def add_card
  end

  def add_payment_card_direct
    @host=request.host.to_s
    @port=request.port.to_s   
    @returnURL="http://#{@host}:#{@port}/websamples/aa/addpaymentcarddirect/add_payment_card_details"
    @cancelURL="http://#{@host}:#{@port}"
    @@ep["SERVICE"]="/AdaptiveAccounts/AddPaymentCard" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "cardNumber"=>params[:creditCardNumber],
             "cardVerificationNumber"=>params[:cardVerificationNumber],
             "createAccountKey"=>params[:CreateAccountKey],
             "cardType"  => params[:creditCardType],
             "confirmationType" =>params[:addPaymentCardDirect][:confirmationtypedirect],
             "emailAddress" =>params[:email],
             "expirationDate.month" =>params[:addPaymentCardDirect][:expDateMonth],
             "expirationDate.year" =>params[:addPaymentCardDirect][:expDateYear],
             "billingAddress.line1" =>params[:address1],
             "billingAddress.line2" =>params[:address2],
             "billingAddress.city" =>params[:city],
             "billingAddress.state" =>params[:addPaymentCardDirect][:state],
             "billingAddress.postalCode" =>params[:zipCode],
             "billingAddress.countryCode" =>params[:country],
             "nameOnCard.firstName" =>params[:firstName],
             "nameOnCard.lastName" =>params[:lastName]
           }
  #Make the call to PayPal to Add Payment Card on behalf of the caller If an error occured, show the resulting errors
            @transaction = @caller.call(req)
  if (@transaction.success?)
        session[:addPaymentCardDirect_response]=@transaction.response   
        redirect_to :controller => 'addpaymentcarddirect',:action => 'add_payment_card_details'
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end
  
  def add_payment_card_details
    @response = session[:addPaymentCardDirect_response]
    @fundingSourceKey =  @response["fundingSourceKey"]
    @execStatus =  @response["execStatus"]
  end

end
