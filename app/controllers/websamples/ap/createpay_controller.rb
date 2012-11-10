require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::CreatepayController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
     render :action => 'create'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def create
	  
  end
  
 def create_pay
    @host=request.host.to_s
    @port=request.port.to_s   
    @cancelURL="http://#{@host}:#{@port}"
    @returnURL="http://#{@host}:#{@port}/websamples/ap/createpay/details"   
    @preapprovalKey =params[:preapprovalkey]
    @@ep["SERVICE"]="/AdaptivePayments/Pay" 
    @caller =  PayPalSDKCallers::Caller.new(false)
        #Generating request string
    req ={
       "requestEnvelope.errorLanguage" => "en_US",
       "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
       "clientDetails.deviceId" =>@@clientDetails["deviceId"],
       "clientDetails.applicationId" => @@clientDetails["applicationId"],
       "receiverList.receiver[0].email"=>params[:receiveremail_0],
       "receiverList.receiver[1].email"=>params[:receiveremail_1],
       "receiverList.receiver[0].amount"=>params[:amount_0],
       "receiverList.receiver[1].amount"=>params[:amount_1],
       "currencyCode"=>params[:createpay][:currency],
       "senderEmail"=>params[:email],
       "actionType"=>params[:actionType],
       "returnUrl" =>@returnURL,
       "cancelUrl"=>@cancelURL
     }
    if(@preapprovalKey!= "")
      req["preapprovalKey"] = @preapprovalKey
    end
    #sending the request string to call method where the PAY API call is made
      @transaction = @caller.call(req)
     if (@transaction.success?)
        session[:createpay_response]=@transaction.response   
        @response = session[:createpay_response]
	@paykey = @response["payKey"]
        @paymentExecStatus=@response["paymentExecStatus"]
          if (@paymentExecStatus.to_s=="CREATED")
              redirect_to :controller => 'createpay',:action => 'details'
          end
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :controller => 'calls', :action => 'exception'
 end
 
 def details
    @response = session[:createpay_response]
    @paykey = @response["payKey"]
    @@ep["SERVICE"]="/AdaptivePayments/PaymentDetails" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    #sending the request string to call method where the paymentDetails API call is made
    @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey" =>@paykey
    }
    )  
     if (@transaction.success?)
      session[:paydetails_response]=@transaction.response 
      redirect_to :controller => 'createpay',:action => 'thanks'
    else
      session[:paypal_error]=@transaction.response 
      redirect_to :controller => 'calls', :action => 'error'
    end 
 end
 
  def thanks
    @response = session[:paydetails_response]
    @TransactionStatus =  @response["status"]
    @paykey =  @response["payKey"]
  end

end
