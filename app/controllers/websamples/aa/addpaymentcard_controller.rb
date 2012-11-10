require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::AddpaymentcardController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
    redirect_to :action => 'add_card'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def add_card
  end
  
  def add_payment_card
    @host=request.host.to_s
    @port=request.port.to_s   
    @returnURL="http://#{@host}:#{@port}/websamples/aa/addpaymentcard/add_payment_card_details"
    @cancelURL="http://#{@host}:#{@port}/websamples/aa/addpaymentcard/add_card"
    @@ep["SERVICE"]="/AdaptiveAccounts/AddPaymentCard" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "cardNumber"=>params[:creditCardNumber],
             "cardType"  => params[:creditCardType],
             "confirmationType" =>params[:addPaymentCard][:confirmationtype],
             "emailAddress" =>params[:email],
             "expirationDate.month" =>params[:addPaymentCard][:expDateMonth],
             "expirationDate.year" =>params[:addPaymentCard][:expDateYear],
             "billingAddress.line1" =>params[:address1],
             "billingAddress.line2" =>params[:address2],
             "billingAddress.city" =>params[:city],
             "billingAddress.state" =>params[:addPaymentCard][:state],
             "billingAddress.postalCode" =>params[:zipCode],
             "billingAddress.countryCode" =>params[:country],
             "nameOnCard.firstName" =>params[:firstName],
             "nameOnCard.lastName" =>params[:lastName],
             "webOptions.cancelUrl" => @cancelURL,
             "webOptions.cancelUrlDescription" => "cancelurl",
             "webOptions.returnUrl" => @returnURL,
             "webOptions.returnUrlDescription" => "returnurl"
           }
 #Make the call to PayPal to Add Payment Card on behalf of the caller If an error occured, show the resulting errors
            @transaction = @caller.call(req)
  if (@transaction.success?)
        session[:addPaymentCard_response]=@transaction.response   
        @response = session[:addPaymentCard_response]
        @redirectUrl=@response["redirectURL"]
        # If response is sucess then redirect to the URL returned from the server.
         redirect_to  "#{@redirectUrl}"
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end

  def add_payment_card_details
    @response = session[:addPaymentCard_response]
    @fundingSourceKey =  @response["fundingSourceKey"]
    @execStatus =  @response["execStatus"]
  end

end
