require 'cgi'
require 'profile'
require 'caller'
class Websamples::Ap::PreapprovaldetailsController < ApplicationController
    @@profile = PayPalSDKProfiles::Profile
   @@ep=@@profile.endpoints
   @@clientDetails=@@profile.client_details
   
  def begin
  reset_session
    render :action => 'getPreapprovalDetails'
  rescue Errno::ENOENT => exception
    flash[:error] = exception
    redirect_to :action => 'index' 
  end
  
  def getPreapprovalDetails
  end
  
   def preapproval_details
    @@ep["SERVICE"]="/AdaptivePayments/PreapprovalDetails" 
    @caller =  PayPalSDKCallers::Caller.new(false)
    session[:preapprovalKey]=params[:preapprovalkey]
    #sending the request string to call method where the preapprovalDetails API call is made
    @transaction = @caller.call(
    {
       "requestEnvelope.errorLanguage" => "en_US",
       "preapprovalKey" => params[:preapprovalkey]
    }
    )  
     if (@transaction.success?)
      session[:paydetails_response]=@transaction.response 
      redirect_to :controller => 'preapprovaldetails',:action => 'details'
    else
      session[:paypal_error]=@transaction.response 
      redirect_to :controller => 'calls', :action => 'error'
     end  
  end  

  def details
    @response = session[:paydetails_response]
    @preapprovalkey =  session[:preapprovalKey]
    @CurPaymentsAmount = @response["curPaymentsAmount"]
    @Status = @response["status"]
    @curPeriodAttempts = @response["curPeriodAttempts"]
    @Approvedstatus = @response["approved"]
  end

end
