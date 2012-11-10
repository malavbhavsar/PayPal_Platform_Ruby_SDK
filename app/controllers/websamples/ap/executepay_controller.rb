
require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::ExecutepayController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def begin
  reset_session
    redirect_to :action => 'execute', :paykey => params[:paykey]
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
  
  def execute
    session[:paykey]=params[:paykey]
    @paykey=params[:paykey]
  end

  def execute_pay
    @@ep["SERVICE"]="/AdaptivePayments/ExecutePayment" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey"=>params[:paykey]
    }
    )       
    
     if (@transaction.success?)
        session[:executePay_response]=@transaction.response   
        redirect_to :controller => 'executepay',:action => 'thanks'
     else
        session[:paypal_error]=@transaction.response 
        redirect_to :controller => 'calls', :action => 'error'
  end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :controller => 'calls', :action => 'exception'
  end
  
  def thanks
     @response = session[:executePay_response]
     @paymentExecStatus=@response["paymentExecStatus"]
     @ack=@response["responseEnvelope.ack"]
     @CorrelationId=@response["responseEnvelope.correlationId"]
     @timestamp=@response["responseEnvelope.timestamp"]
     @build=@response["responseEnvelope.build"]
     @paykey=session[:paykey]
  end

end
