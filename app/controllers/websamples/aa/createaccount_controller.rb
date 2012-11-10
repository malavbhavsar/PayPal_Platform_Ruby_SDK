require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::CreateaccountController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   @@header = @@profile.headers
  def begin
 reset_session
    render :action => 'create'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def create
  end
  
 def create_account
    @host=request.host.to_s
    @port=request.port.to_s   
    @returnURL="http://#{@host}:#{@port}/websamples/aa/createaccount/account_details"
    @@header["X-PAYPAL-SANDBOX-EMAIL-ADDRESS"] = params[:devCentral]
    @@ep["SERVICE"]="/AdaptiveAccounts/CreateAccount" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
             "accountType"=>params[:createaccount][:account],
             "address.city" =>params[:city],
             "address.countryCode" =>params[:countrycode],
             "address.line1"=>params[:address1],
             "address.line2"=>params[:address2],
             "address.postalCode" =>params[:zipcode],
             "address.state" =>params[:createaccount][:state],
             "citizenshipCountryCode"=>params[:citzenshipcountry],
             "contactPhoneNumber" =>params[:phone],
             "currencyCode" =>params[:createaccount][:currency],
             "dateOfBirth"=>params[:dob],
             "name.firstName" =>params[:firstname],
             "name.lastName" =>params[:lastname],
             "name.middleName"=>params[:middlename],
             "name.salutation" =>params[:createaccount][:salutation],
             "notificationURL" =>params[:url],
             "partnerField1"=>params[:p1],
             "partnerField2" =>params[:p2],
             "partnerField3"=>params[:p3],
             "partnerField4" =>params[:p4],
             "partnerField5" =>params[:p5],
             "preferredLanguageCode"=>"en_US",
             "createAccountWebOptions.returnUrl" =>@returnURL,
             "registrationType" =>"WEB",
             "sandboxEmailAddress"=>params[:devCentral],
             "emailAddress"=>params[:email]
           }
           
    #Make the call to PayPal to create  Account on behalf of the caller If an error occured, show the resulting errors
    @transaction = @caller.call(req)

     if (@transaction.success?)
        session[:createAccount_response]=@transaction.response   
        @response = session[:createAccount_response]
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

  def account_details
    @response = session[:createAccount_response]
    @correlationId =  @response["responseEnvelope.correlationId"]
    @createAccountKey =  @response["createAccountKey"]
    @execStatus =  @response["execStatus"]
  end

end
