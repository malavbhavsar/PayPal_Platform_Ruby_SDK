require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::AddbankaccountController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def begin
 reset_session
    redirect_to :action => 'add_bank'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def add_bank
  end

  def add_bank_account
    @host=request.host.to_s
    @port=request.port.to_s   
    @returnURL="http://#{@host}:#{@port}/websamples/aa/addbankaccount/add_bank_account_details"
    @cancelURL="http://#{@host}:#{@port}/websamples/aa/addbankaccount/add_bank"
    @@ep["SERVICE"]="/AdaptiveAccounts/AddBankAccount" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "bankAccountNumber"=>params[:BankAccountNumber],
             "bankAccountType" =>params[:addBankAccount][:accounttype],
             "bankCountryCode" =>params[:BankCountryCode],
             "bankName"=>params[:BankName],
             "confirmationType"=>params[:addBankAccount][:confirmationtype],
             "emailAddress" =>params[:email],
             "routingNumber" =>params[:RoutingNumber],
             "webOptions.cancelUrl" => @cancelURL,
             "webOptions.cancelUrlDescription" => "cancelurl",
             "webOptions.returnUrl" => @returnURL,
             "webOptions.returnUrlDescription" => "returnurl"
           }
  #Make the call to PayPal to Add Bank Account on behalf of the caller If an error occured, show the resulting errors
            @transaction = @caller.call(req)

  if (@transaction.success?)
        session[:addBankAccount_response]=@transaction.response   
        @response = session[:addBankAccount_response]
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
  

  def add_bank_account_details
    @response = session[:addBankAccount_response]
    @fundingSourceKey =  @response["fundingSourceKey"]
    @execStatus =  @response["execStatus"]
  end

end
