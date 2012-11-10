require 'cgi'
require 'profile'
require 'caller'
class Websamples::Aa::CreateaccountbusinessController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   @@header = @@profile.headers
   
  def begin
  reset_session
    redirect_to :action => 'create'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def create
  end
  
 def create_account
    @host=request.host.to_s
    @port=request.port.to_s   
    @returnURL="http://#{@host}:#{@port}/websamples/aa/createaccountbusiness/account_details"
    @@ep["SERVICE"]="/AdaptiveAccounts/CreateAccount" 
    @@header["X-PAYPAL-SANDBOX-EMAIL-ADDRESS"] = params[:devCentral]
    @caller =  PayPalSDKCallers::Caller.new(false)
    req={
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
             "clientDetails.deviceId" =>@@clientDetails["deviceId"],
             "clientDetails.applicationId" => @@clientDetails["applicationId"],
              "accountType"=>params[:AccountType],
             "address.city" =>params[:city],
             "address.countryCode" =>params[:countrycode],
             "address.line1"=>params[:address1],
             "address.line2"=>params[:address2],
             "address.postalCode" =>params[:zipcode],
             "address.state" =>params[:createbusiness][:state],
             "citizenshipCountryCode"=>params[:citzenshipcountry],
             "contactPhoneNumber" =>params[:phone],
             "currencyCode" =>params[:createbusiness][:currency],
             "dateOfBirth"=>params[:dob],
             "name.firstName" =>params[:firstname],
             "name.lastName" =>params[:lastname],
             "name.middleName"=>params[:middlename],
             "name.salutation" =>params[:createbusiness][:salutation],
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
             "emailAddress"=>params[:email],
            "businessInfo.averageMonthlyVolume" =>params[:averageMonthlyVolume],
            "businessInfo.averagePrice" =>params[:averagePrice],
            "businessInfo.businessAddress.city" =>params[:bizcity],
             "businessInfo.businessAddress.countryCode" =>params[:bizcountrycode],
             "businessInfo.businessAddress.line1" =>params[:bizaddress1],
             "businessInfo.businessAddress.line2" =>params[:bizaddress2],
             "businessInfo.businessAddress.postalCode" =>params[:bizzipcode],
             "businessInfo.businessAddress.state" =>params[:createbusiness][:bizstate],
             "businessInfo.businessName" =>params[:businessname],
             "businessInfo.businessType" =>params[:createbusiness][:businesstype],
             "businessInfo.customerServiceEmail" =>params[:customerServiceEmail],
             "businessInfo.customerServicePhone" =>params[:customerServicePhone],
             "businessInfo.dateOfEstablishment" =>params[:dateOfEstablishment],
              "businessInfo.percentageRevenueFromOnline" =>params[:percentageRevenueFromOnline],
             "businessInfo.salesVenue" =>params[:salesVenue],
              "businessInfo.category" =>params[:category],
             "businessInfo.subCategory" =>params[:subcategory],           
             "businessInfo.webSite" =>params[:webSite],
              "businessInfo.workPhone" =>params[:workphone]
           }
           
           #Make the call to PayPal to create business Account on behalf of the caller If an error occured, show the resulting errors
              @transaction = @caller.call(req)

  if (@transaction.success?)
        session[:createAccountBiz_response]=@transaction.response   
        @response = session[:createAccountBiz_response]
        @redirectUrl=@response["redirectURL"]
    
       redirect_to  "#{@redirectUrl}"
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
  end
  
  def account_details
    @response = session[:createAccountBiz_response]
    @correlationId =  @response["responseEnvelope.correlationId"]
    @createAccountKey =  @response["createAccountKey"]
    @execStatus =  @response["execStatus"]
  end

end
