require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::AddbankaccountdirectController < ApplicationController
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
 def add_bank_account_direct
    @host=request.host.to_s
    @port=request.port.to_s   
    @returnURL="http://#{@host}:#{@port}/websamples/aa/addbankaccountdirect/add_bank_account_details"
    @cancelURL="http://#{@host}:#{@port}"
    @@ep["SERVICE"]="/AdaptiveAccounts/AddBankAccount" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "bankAccountNumber"=>params[:BankAccountNumber],
             "bankAccountType" =>params[:addBankAccountDirect][:accounttype],
             "bankCountryCode" =>params[:BankCountryCode],
             "bankName"=>params[:BankName],
             "confirmationType"=>params[:addBankAccountDirect][:confirmationtypedirect],
             "emailAddress" =>params[:email],
             "routingNumber" =>params[:RoutingNumber],
             "webOptions.cancelUrl" => @cancelURL,
             "webOptions.cancelUrlDescription" => "cancelurl",
             "webOptions.returnUrl" => @returnURL,
             "webOptions.returnUrlDescription" => "returnurl",
             "createAccountKey"=>params[:CreateAccountKey]
           }
  @transaction = @caller.call(req)
    if (@transaction.success?)
        session[:addBankAccountDirect_response]=@transaction.response   
        redirect_to :controller => 'addbankaccountdirect',:action => 'add_bank_account_details'
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
     rescue Errno::ENOENT => exception
    flash[:error] = exception
  end
  
  def add_bank_account_details
    @response = session[:addBankAccountDirect_response]
    @fundingSourceKey =  @response["fundingSourceKey"]
    @execStatus =  @response["execStatus"]
  end

end
