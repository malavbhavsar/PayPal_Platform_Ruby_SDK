
require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::RefundController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
    render :action => 'refund'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
  
  def refund
  end
  
  def do_refund
     @@ep["SERVICE"]="/AdaptivePayments/Refund" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    #sending the request string to call method where the paymentDetails API call is made
    @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey" =>params[:paykey],
      "currencyCode"=>params[:refund][:currency],
      "receiverList.receiver[0].email"=>params[:receiveremail_0],
      "receiverList.receiver[0].amount"=>params[:amount_0]
    }
    )  
       if (@transaction.success?)
          session[:refund_response]=@transaction.response 
          redirect_to :controller => 'refund',:action => 'details'
      else
          session[:paypal_error]=@transaction.response 
          redirect_to :controller => 'calls', :action => 'error'
     end  
   end
   
  def details
    @response = session[:refund_response]
    @refundStatus=@response["refundInfoList.refundInfo(0).refundStatus"]
    @receiver=@response["refundInfoList.refundInfo(0).receiver.email"]
    @amount=@response["refundInfoList.refundInfo(0).receiver.amount"]
  end

end
