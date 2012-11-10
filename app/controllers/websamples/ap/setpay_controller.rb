
require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::SetpayController < ApplicationController
     @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
    render :action => 'pay'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end

  def pay
    
  end

# Pay API call  
  def set_pay  
    @host=request.host.to_s
    @port=request.port.to_s   
    @cancelURL="http://#{@host}:#{@port}"
    @returnURL="http://#{@host}:#{@port}/websamples/ap/setpay/pay_details"   
     @preapprovalKey =params[:preapprovalkey]
    @@ep["SERVICE"]="/AdaptivePayments/Pay" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    req={
       "requestEnvelope.errorLanguage" => "en_US",
       "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
       "clientDetails.deviceId" =>@@clientDetails["deviceId"],
       "clientDetails.applicationId" => @@clientDetails["applicationId"],
       "receiverList.receiver[0].email"=>params[:receiveremail_0],
       "receiverList.receiver[1].email"=>params[:receiveremail_1],
       "receiverList.receiver[0].amount"=>params[:amount_0],
       "receiverList.receiver[1].amount"=>params[:amount_1],
       "currencyCode"=>params[:setpay][:currency],
       "senderEmail"=>params[:email],
       "actionType"=>"PAY",
       "returnUrl" =>@returnURL,
       "cancelUrl"=>@cancelURL
    }
    if(@preapprovalKey!= "")
      req["preapprovalKey"] = @preapprovalKey
    end
    #sending the request string to call method where the PAY API call is made
    @transaction = @caller.call(req)

      if (@transaction.success?)
        session[:setpay_response]=@transaction.response   
        @response = session[:setpay_response]
        @paykey = @response["payKey"]
        @paymentExecStatus=@response["paymentExecStatus"]
      #if "paymentExecStatus" is completed redirect to pay_details method else redirect to sandbox with paykey
          if (@paymentExecStatus.to_s=="COMPLETED")
              redirect_to :controller => 'setpay',:action => 'pay_details'
          else
              redirect_to "https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey=#{@paykey}"
          end
   else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
   end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :controller => 'calls', :action => 'exception'
  end        
  

  def pay_details
    @response = session[:setpay_response]
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
      redirect_to :controller => 'setpay',:action => 'thanks'
    else
      session[:paypal_error]=@transaction.response 
      redirect_to :controller => 'calls', :action => 'error'
     end  
  end  
  
  def thanks    
    @response = session[:paydetails_response]
    @TransactionStatus =  @response["status"]
    @paykey =  @response["payKey"]
    @senderEmai =  @response["senderEmail"]
    @currencyCode =  @response["currencyCode"]
    @feesPayer =  @response["feesPayer"]
    @actionType =  @response["actionType"]
  end
end