require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::SetpaymentoptionController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def begin
  reset_session
    redirect_to :action => 'paymentOption', :paykey => params[:paykey]
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
  
  def paymentOption
      session[:paykey]=params[:paykey]
      @paykey=params[:paykey]
  end
 def setpaymetoption
    @@ep["SERVICE"]="/AdaptivePayments/SetPaymentOptions" 
    @institutionId=params[:institutionId]
    @caller =  PayPalSDKCallers::Caller.new(false)
     req=
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
      "clientDetails.deviceId" =>@@clientDetails["deviceId"],
      "clientDetails.applicationId" => @@clientDetails["applicationId"],
      "payKey"=>params[:paykey],
      "displayOptions.emailHeaderImageUrl" =>params[:headerImage],
      "displayOptions.emailMarketingImageUrl" =>params[:marketingImage]
      }
        if(params[:institutionId]!= "")
          req["initiatingEntity.institutionCustomer.institutionId"] = params[:institutionId]
        end
        if(params[:firstName]!= "")
          req["initiatingEntity.institutionCustomer.firstName"] = params[:firstName]
        end
        if(params[:lastName]!= "")
          req["initiatingEntity.institutionCustomer.lastName"] = params[:lastName]
        end
        if(params[:displayName]!= "")
          req["initiatingEntity.institutionCustomer.displayName"] = params[:displayName]
        end
        if(params[:customerId]!= "")
          req["initiatingEntity.institutionCustomer.institutionCustomerId"] = params[:customerId]
        end
       if(params[:countryCode]!= "")
          req["initiatingEntity.institutionCustomer.countryCode"] = params[:countryCode]
       end
      if(params[:email]!= "")
          req["initiatingEntity.institutionCustomer.email"] = params[:email]
      end




    #sending the request string to call method where the PAY API call is made
      @transaction = @caller.call(req)
      if (@transaction.success?)
        session[:paymentOption_response]=@transaction.response 
        redirect_to :controller => 'setpaymentoption',:action => 'thanks'
      else
        session[:paypal_error]=@transaction.response 
        redirect_to :controller => 'calls', :action => 'error'
      end  
      rescue Errno::ENOENT => exception
      flash[:error] = exception
      redirect_to :controller => 'calls', :action => 'exception'
  end
  
  def thanks
      @response = session[:paymentOption_response]
     @ack=@response["responseEnvelope.ack"]
     @CorrelationId=@response["responseEnvelope.correlationId"]
     @timestamp=@response["responseEnvelope.timestamp"]
     @build=@response["responseEnvelope.build"]
     @paykey=session[:paykey]
  end

end
