
require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::SetpreapprovalController < ApplicationController
   @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
  def preapproval
  reset_session
    date = Time.new
    @startdate=date.strftime("%Y-%m-%d")
    @enddate="#{date.year + 1}-#{date.strftime("%m")}-#{date.strftime("%d")}"
  end

 def set_preapproval
    @host=request.host.to_s
    @port=request.port.to_s   
    @cancelURL="http://#{@host}:#{@port}"
    @returnURL="http://#{@host}:#{@port}/websamples/ap/setpreapproval/preapproval_details"   
    
    @@ep["SERVICE"]="/AdaptivePayments/Preapproval" 
    @caller =  PayPalSDKCallers::Caller.new(false)
       @transaction = @caller.call(
    {
      "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>@@clientDetails["ipAddress"],
      "clientDetails.deviceId" =>@@clientDetails["deviceId"],
      "clientDetails.applicationId" => @@clientDetails["applicationId"],
      "returnUrl" =>@returnURL,
      "cancelUrl"=>@cancelURL,
      "currencyCode"=>params[:setpreapproval][:currency],
      "startingDate" =>params[:startDate],
      "endingDate" =>params[:endDate],
      "maxNumberOfPayments" => params[:maxNumberOfPayments],
      "maxTotalAmountOfAllPayments" => params[:maxTotalAmountOfAllPayments],
      "requestEnvelope.senderEmail"=>params[:email]
    }
    )  
 if (@transaction.success?)
        session[:setpreapproval_response]=@transaction.response   
        @response = session[:setpreapproval_response]
        @preapprovalkey=@response["preapprovalKey"]
        redirect_to "https://www.sandbox.paypal.com/webscr?cmd=_ap-preapproval&preapprovalkey=#{@preapprovalkey}"
  else
     session[:paypal_error]=@transaction.response
     redirect_to :controller => 'calls', :action => 'error'
  end
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :controller => 'calls', :action => 'exception'    
 end
 
  def preapproval_details
    @response = session[:setpreapproval_response]
    @preapprovalkey = @response["preapprovalKey"]
    @@ep["SERVICE"]="/AdaptivePayments/PreapprovalDetails" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    @transaction = @caller.call(
    {
       "requestEnvelope.errorLanguage" => "en_US",
       "preapprovalKey" => @preapprovalkey
    }
    )
     if (@transaction.success?)
      session[:preapprovaldetails_response]=@transaction.response
      redirect_to :controller => 'setpreapproval',:action => 'details'
    else
      session[:paypal_error]=@transaction.response 
      redirect_to :controller => 'calls', :action => 'error'
     end
   end

  def details
    @response = session[:preapprovaldetails_response]
    @preapprovalResponse=session[:setpreapproval_response]
    @preapprovalkey = @preapprovalResponse["preapprovalKey"]
    @CurPaymentsAmount = @response["curPaymentsAmount"]
    @Status = @response["status"]
    @curPeriodAttempts = @response["curPeriodAttempts"]
    @Approvedstatus = @response["approved"]
  end

end
