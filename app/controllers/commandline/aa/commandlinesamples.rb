require 'cgi'
require 'net/http'
require 'net/https'
require 'uri'
require 'log4r'
require 'singleton'

@@endpoints = {"SERVER" => "svcs.sandbox.paypal.com", "SERVICE" => ""}
@@client_info = { "VERSION" => "60.0", "SOURCE" => "PayPalRubySDKV1.2.0"}
@@headers = {
        "Content-Type" => "html/text",
        "X-PAYPAL-SERVICE-VERSION" => "1.0.0",
        "X-PAYPAL-SECURITY-USERID" => "platfo_1255077030_biz_api1.gmail.com",
        "X-PAYPAL-SECURITY-PASSWORD" =>"1255077037", 
        "X-PAYPAL-SECURITY-SIGNATURE" => "Abg0gYcQyxQvnf2HDJkKtA-p6pqhA1k-KTYE0Gcy1diujFio4io5Vqjf", 
        "X-PAYPAL-APPLICATION-ID" => "APP-80W284485P519543T",
        "X-PAYPAL-DEVICE-IPADDRESS"=>"127.0.0.1" , 
        "X-PAYPAL-REQUEST-DATA-FORMAT" => "NV" , 
        "X-PAYPAL-RESPONSE-DATA-FORMAT" => "NV",
        "X-PAYPAL-SANDBOX-EMAIL-ADDRESS" => "Platform.sdk.seller@gmail.com"
        }  
  
  
  #Method to convert hast to cgi string
  def hash2cgiString(h)
    h.each { |key,value| h[key] = CGI::escape(value.to_s) if (value) }   
    h.sort.map { |a| a.join('=') }.join('&')
  end
  


# Class has a class method which returs the logger to be used for logging.
# All the requests sent and responses received will be logged to a file (filename passed to getLogger method) under logs directroy.
  class Logger  
    include Singleton
    #cattr_accessor :MyLog
    def self.getLogger(filename)    
     
      @@MyLog = Log4r::Logger.new("paypallog")
      # note: The path prepended to filename is based on Rails path structure. 
      Log4r::FileOutputter.new('paypal_log',
                       :filename=> "log/#{filename}",
                       :trunc=>false,
                       :formatter=> MyFormatter)
      @@MyLog.add('paypal_log')
      return @@MyLog
      end  
  end
# Class and method to redfine the log4r formatting.
class MyFormatter < Log4r::Formatter
    def format(event)
      buff = Time.now.strftime("%a %m/%d/%y %H:%M %Z")
      buff += " - #{Log4r::LNAMES[event.level]}"
      buff += " - #{event.data}\n"
    end
  end    
    
    #Method to make call to server. NVP string, header information and end points are given as input
  def call(req)
      @@PayPalLog=Logger.getLogger('PayPal.log') 
      req_data= "#{hash2cgiString(req)}&#{hash2cgiString(@@client_info)}"
      http = Net::HTTP.new(@@endpoints["SERVER"], 443)
      http.verify_mode    = OpenSSL::SSL::VERIFY_NONE #unless ssl_strict
      http.use_ssl = true;  
      @@PayPalLog.info "SENT: #{CGI.unescape(req_data)}"
      @@PayPalLog.info "\n"
      contents, unparseddata = http.post2(@@endpoints["SERVICE"], req_data, @@headers)
      #@@PayPalLog.info "RECEIVED: #{CGI.unescape(unparseddata)}"
      @@PayPalLog.info "\n"
      data = CGI::parse(contents.body)
  end    
    

  #Method to perform Create Personal account API call
  def create_account
    
  @@endpoints["SERVICE"]="/AdaptiveAccounts/CreateAccount"
  
  @email=rand(10 ** 10)
    req=
      {
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-80W284485P519543T",
             "accountType"=>"PERSONAL",
             "address.city" =>"Austin",
             "address.countryCode" =>"US",
             "address.line1"=>"1968 Ape Way",
             "address.line2"=>"Apt 123",
             "address.postalCode" =>"78750",
             "address.state" =>"TX",
             "citizenshipCountryCode"=>"US",
             "contactPhoneNumber" =>"512-691-4160",
             "currencyCode" =>"USD",
             "dateOfBirth"=>"1968-01-01",
             "name.firstName" =>"Bonzop",
             "name.lastName" =>"Zaius",
             "name.middleName"=>"Simore",
             "name.salutation" =>"Dr.",
             "notificationURL" =>"http://stranger.paypal.com/cgi-bin/ipntest.cgi",
             "partnerField1"=>"p1",
             "partnerField2" =>"p2",
             "partnerField3"=>"p3",
             "partnerField4" =>"p4",
             "partnerField5" =>"p5",
             "preferredLanguageCode"=>"en_US",
             "createAccountWebOptions.returnUrl" =>"https://www.yahoo.com",
             "registrationType" =>"WEB",
             "sandboxEmailAddress"=>"Platform.sdk.seller@gmail.com",
             "emailAddress"=>"platfo-""#{@email}""@paypal.com"
  }
  data=call(req)
    if(data["responseEnvelope.ack"][0].to_s=="Success")
      @@emailAddress1 ="platfo-""#{@email}""@paypal.com"
      @@createAccountKey1 =data["createAccountKey"][0].to_s
      puts "CreateAccount Successful!" 
    else
      puts "Transaction CreateAccount Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
  
  
  #Method to perform Create Business account API call
  def create_account_business
    
  @@endpoints["SERVICE"]="/AdaptiveAccounts/CreateAccount"
  
  @email=rand(10 ** 10)
    req=
      {
            "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-1JE4291016473214C",
             "accountType"=>"BUSINESS",
             "address.city" =>"Austin",
             "address.countryCode" =>"US",
             "address.line1"=>"1968 Ape Way",
             "address.line2"=>"Apt 123",
             "address.postalCode" =>"78750",
             "address.state" =>"TX",
            "businessInfo.averageMonthlyVolume" =>"100",
            "businessInfo.averagePrice" =>"100",
            "businessInfo.businessAddress.city" =>"Austin",
             "businessInfo.businessAddress.countryCode" =>"US",
             "businessInfo.businessAddress.line1" =>"1968 Ape Way",
             "businessInfo.businessAddress.line2" =>"Apt 123",
             "businessInfo.businessAddress.postalCode" =>"78750",
             "businessInfo.businessAddress.state" =>"TX",
             "businessInfo.businessName" =>"Bonzop",
             "businessInfo.businessType" =>"INDIVIDUAL",
             "businessInfo.customerServiceEmail" =>"platfo-""#{@email}""@paypal.com",
             "businessInfo.customerServicePhone" =>"512-691-4160",
             "businessInfo.dateOfEstablishment" =>"1968-01-01",
              "businessInfo.percentageRevenueFromOnline" =>"100",
             "businessInfo.salesVenue" =>"WEB",
              "businessInfo.category" =>"1001",
             "businessInfo.subCategory" =>"2002",           
             "businessInfo.webSite" =>"https://www.x.com",
              "businessInfo.workPhone" =>"512-691-4160",
              "citizenshipCountryCode"=>"US",
              "contactPhoneNumber" =>"512-691-4160",
             "createAccountWebOptions.returnUrl" =>"https://www.yahoo.com",
             "currencyCode" =>"USD",
             "dateOfBirth"=>"1968-01-01",
              "emailAddress"=>"platfo-""#{@email}""@paypal.com",
             "name.firstName" =>"Bonzop",
             "name.middleName"=>"Simore",
             "name.lastName" =>"Zaius",
             "name.salutation" =>"Dr.",
             "notificationURL" =>"http://stranger.paypal.com/cgi-bin/ipntest.cgi",
             "preferredLanguageCode"=>"en_US",
             "registrationType" =>"WEB",
             "partnerField1"=>"p1",
             "partnerField2" =>"p2",
             "partnerField3"=>"p3",
             "partnerField4" =>"p4",
             "partnerField5" =>"p5",
             "sandboxEmailAddress"=>"Platform.sdk.seller@gmail.com"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      @@emailAddress2 ="platfo-""#{@email}""@paypal.com"
      @@createAccountKey2 =data["createAccountKey"][0].to_s
      puts "CreateAccount Business API call Successful!" 
    else
      puts "Transaction CreateAccount Business Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end  
  

  #Method to perform Add Bank Account API call
  def add_bank_account
    
  @@endpoints["SERVICE"]="/AdaptiveAccounts/AddBankAccount"
  @email=rand(10 ** 10)
    req=
      {
            "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-1JE4291016473214C",
             "bankAccountNumber"=>"162951",
             "bankAccountType" =>"CHECKING",
             "bankCountryCode" =>"US",
             "bankName"=>"Huntington Bank",
             "confirmationType"=>"WEB",
             "emailAddress" =>"platfo_1255611349_biz@gmail.com",
             "routingNumber" =>"111900659",
             "webOptions.cancelUrl" => "http://www.google.com",
             "webOptions.cancelUrlDescription" => "cancelurl",
             "webOptions.returnUrl" => "http://www.yahoo.com",
             "webOptions.returnUrlDescription" => "returnurl"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      puts "Add bank AccountAPI call Successful!" 
    else
      puts "Transaction add bank Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
  
    #Method to perform Add Bank Account direct API call
  def add_bank_account_direct 
  @Number ="160000"
  @number1 =rand(160000 + 1)
  @bankAccountNumber= @number1
  @@endpoints["SERVICE"]="/AdaptiveAccounts/AddBankAccount"
    req=
      {
            "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-1JE4291016473214C",
             "bankAccountNumber"=>@bankAccountNumber,
             "bankAccountType" =>"CHECKING",
             "bankCountryCode" =>"US",
             "bankName"=>"Huntington Bank",
             "confirmationType"=>"NONE",
             "emailAddress" =>@@emailAddress1,
             "createAccountKey" =>@@createAccountKey1,
             "routingNumber" =>"021473030",
             "webOptions.cancelUrl" => "http://www.google.com",
             "webOptions.cancelUrlDescription" => "cancelurl",
             "webOptions.returnUrl" => "http://www.yahoo.com",
             "webOptions.returnUrlDescription" => "returnurl"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      puts "Add bank Account Direct API call Successful!" 
    else
      puts "Transaction add bank direct Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
  #Method to perform Add Payment Card API call
  def add_payment_card 
    @@endpoints["SERVICE"]="/AdaptiveAccounts/AddPaymentCard"
    @email=rand(10 ** 10)
    req=
      {
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-1JE4291016473214C",
             "cardNumber"=>"4943871033202264",
             "cardType"  => "Visa",
             "confirmationType" =>"WEB",
             "emailAddress" =>"platfo_1255611349_biz@gmail.com",
             "expirationDate.month" =>"01",
             "expirationDate.year" =>"2014",
             "billingAddress.line1" =>"1 Main St",
             "billingAddress.line2" =>"2nd cross",
             "billingAddress.city" =>"Austin",
             "billingAddress.state" =>"TX",
             "billingAddress.postalCode" =>"78750",
             "billingAddress.countryCode" =>"US",
             "nameOnCard.firstName" =>"John",
             "nameOnCard.lastName" =>"Deo",
             "webOptions.cancelUrl" => "http://www.google.com",
             "webOptions.cancelUrlDescription" => "cancelurl",
             "webOptions.returnUrl" => "http://www.yahoo.com",
             "webOptions.returnUrlDescription" => "returnurl"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      puts "Add payment card API call Successful!" 
    else
      puts "Transaction payment card Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
  
def range_rand(min,max)
  @@card=min + rand(max-min)
end
  
   #Method to perform Add Payment Card API call
  def add_payment_card_direct
    @carddnum= rand(1000)
    @cardnumber= range_rand(4333111311311311,4999999999999999)
    #@cardnumber=4111111111111111 +@carddnum
    @@endpoints["SERVICE"]="/AdaptiveAccounts/AddPaymentCard"
    req=
      {
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-1JE4291016473214C",
             "cardNumber"=>@cardnumber,
             "cardVerificationNumber"=>"956",
             "createAccountKey"=>@@createAccountKey2,
             "cardType"  =>"Visa",
             "confirmationType" =>"NONE",
             "emailAddress" =>@@emailAddress2,
             "expirationDate.month" =>"01",
             "expirationDate.year" =>"2014",
             "billingAddress.line1" =>"1 Main St",
             "billingAddress.line2" =>"2nd cross",
             "billingAddress.city" =>"Austin",
             "billingAddress.state" =>"TX",
             "billingAddress.postalCode" =>"78750",
             "billingAddress.countryCode" =>"US",
             "nameOnCard.firstName" =>"John",
             "nameOnCard.lastName" =>"Deo"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      puts "Add payment card direct API call Successful!" 
    else
      puts "Transaction add payment card direct Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
  
  #Method to perform Set Funding Source Confirmed API call
  def set_fundingsource_confirmed
      puts "SetFundingSourceConfirmed - one of the input parameters require web flow" 
  end
  
    #Method to perform Get Verified Status API call
  def get_verified_status
    
  @@endpoints["SERVICE"]="/AdaptiveAccounts/GetVerifiedStatus"
    req=
      {
             "requestEnvelope.errorLanguage" => "en_US",
             "clientDetails.ipAddress"=>"127.0.0.1",
             "clientDetails.deviceId" =>"mydevice",
             "clientDetails.applicationId" => "APP-1JE4291016473214C",
             "emailAddress"=>@@emailAddress2,
             "matchCriteria" =>"NAME",
             "firstName" =>"Bonzop",
             "lastName"=>"Zaius"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      puts "Get Verified Status  Successful!" 
    else
      puts "Transaction  Get Verified Status Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end

puts "Running Adaptive Accounts Samples..."
create_account
create_account_business
add_bank_account
add_bank_account_direct
add_payment_card
add_payment_card_direct
set_fundingsource_confirmed
get_verified_status

puts ""
puts "***** Done *****"
print STDIN.getc



