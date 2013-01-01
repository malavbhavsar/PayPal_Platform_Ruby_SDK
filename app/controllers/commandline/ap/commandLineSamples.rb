require 'cgi'
require 'net/http'
require 'net/https'
require 'uri'
require 'log4r'
require 'singleton'

@@endpoints = {"SERVER" => "svcs.sandbox.paypal.com", "SERVICE" => ""}
@@client_info = { "VERSION" => "60.0", "SOURCE" => "PayPalRubySDKV1.2.0"}
@@headers = {"Content-Type" => "html/text","X-PAYPAL-SERVICE-VERSION" => "1.0.0","X-PAYPAL-SECURITY-USERID" => "platfo_1255077030_biz_api1.gmail.com","X-PAYPAL-SECURITY-PASSWORD" =>"1255077037", "X-PAYPAL-SECURITY-SIGNATURE" => "Abg0gYcQyxQvnf2HDJkKtA-p6pqhA1k-KTYE0Gcy1diujFio4io5Vqjf", "X-PAYPAL-APPLICATION-ID" => "APP-80W284485P519543T","X-PAYPAL-DEVICE-IPADDRESS"=>"127.0.0.1" , "X-PAYPAL-REQUEST-DATA-FORMAT" => "NV" , "X-PAYPAL-RESPONSE-DATA-FORMAT" => "NV"}  
  
  
  #Method to convert hast to cgi string
  def hash2cgiString(h)
    h.each { |key,value| h[key] = CGI::escape(value.to_s) if (value) }   
    h.sort.map { |a| a.join('=') }.join('&')
  end
  
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
# Class has a class method which returs the logger to be used for logging.
# All the requests sent and responses received will be logged to a file (filename passed to getLogger method) under logs directroy.
 
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
    

  #Method to perform Create Pay API call, on successfull call paykey is returned else error message is returned
  def createpay
    
  @@endpoints["SERVICE"]="/AdaptivePayments/Pay"
    req=
      {
          "requestEnvelope.errorLanguage" => "en_US",
          "clientDetails.ipAddress"=>"127.0.0.1",
          "clientDetails.deviceId" =>"mydevice",
          "clientDetails.applicationId" => "APP-1JE4291016473214C",
          "receiverList.receiver[0].email"=>"platfo_1255612361_per@gmail.com",
          "receiverList.receiver[1].email"=>"platfo_1255611349_biz@gmail.com",
          "receiverList.receiver[0].amount"=>"1.00",
          "receiverList.receiver[1].amount"=>"1.00",
          "currencyCode"=>"USD",
          "senderEmail"=>"platfo_1255077030_biz@gmail.com",
          "actionType"=>"CREATE",
          "returnUrl" =>"http://www.hawaii.com",
          "cancelUrl"=>"http://www.hawaii.edu"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      @@createPaykey= data["payKey"][0]
      puts "Transaction create Pay successfull! paykey is #{data["payKey"][0]}"
    else
      puts "Transaction Create Pay Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
   #Method to perform SetPAymentOption API call
  def setPaymentOption
    
  @@endpoints["SERVICE"]="/AdaptivePayments/SetPaymentOptions"
    req=
      {
      "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>"127.0.0.1",
      "clientDetails.deviceId" =>"mydevice",
      "clientDetails.applicationId" =>  "APP-1JE4291016473214C",
      "payKey"=>@@createPaykey
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      puts "Transaction SetPaymentOption successfull!" 
    else
      puts "Transaction SetPaymentOption Option Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
  #Method to perform ExecutePAyment API call
  def executePay
    
  @@endpoints["SERVICE"]="/AdaptivePayments/ExecutePayment"
    req=
      {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey"=>@@createPaykey
     }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      if(data["paymentExecStatus"][0].to_s=="COMPLETED")
        puts "Transaction ExcecutePayment successfull!" 
      end
    else
      puts "Transaction ExcecutePayment Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
  end
  
    #Method to perform GetPAymentOption API call
  def getPaymentOption
    
  @@endpoints["SERVICE"]="/AdaptivePayments/GetPaymentOptions"
    req=
      {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey"=>@@createPaykey
     }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
        puts "Transaction GetPaymentOption successfull!" 
    else
      puts "Transaction GetPaymentOption Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
end


  #Method to perform Pay API call, on successfull call paykey is returned else error message is returned
  def setpay
    
  @@endpoints["SERVICE"]="/AdaptivePayments/Pay"
    req=
      {
          "requestEnvelope.errorLanguage" => "en_US",
          "clientDetails.ipAddress"=>"127.0.0.1",
          "clientDetails.deviceId" =>"mydevice",
          "clientDetails.applicationId" => "APP-1JE4291016473214C",
          "receiverList.receiver[0].email"=>"platfo_1255612361_per@gmail.com",
          "receiverList.receiver[1].email"=>"platfo_1255611349_biz@gmail.com",
          "receiverList.receiver[0].amount"=>"1.00",
          "receiverList.receiver[1].amount"=>"1.00",
          "currencyCode"=>"USD",
          "senderEmail"=>"platfo_1255077030_biz@gmail.com",
          "actionType"=>"PAY",
          "returnUrl" =>"http://www.hawaii.com",
          "cancelUrl"=>"http://www.hawaii.edu"
  }
  data=call(req)

    if(data["responseEnvelope.ack"][0].to_s=="Success")
      @@paykey= data["payKey"][0]
      puts "Transaction Pay successfull! paykey is #{data["payKey"][0]}"
    else
      puts "Transaction Pay Failed:"
      puts "error Id:#{data["error(0).errorId"]}"
      puts "error message:#{data["error(0).message"]}"
    end  
end

#Method to make PayDetails API call, paykey is given as input is obtained from setpay method
def payDetails
  @@endpoints["SERVICE"]="/AdaptivePayments/PaymentDetails"
  req=
 {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey" =>@@paykey
  }
  data=call(req)  
  if(data["responseEnvelope.ack"][0].to_s=="Success")
    puts "Transaction PaymentDetails is successfull!" 
  else
    puts "Transaction PaymentDetails Failed:"
    puts "error Id:#{data["error(0).errorId"]}"
    puts "error message:#{data["error(0).message"]}"
  end  
end  

#Method to make Refund API call, paykey is given as input is obtained from setpay method
def refund
   @@endpoints["SERVICE"]="/AdaptivePayments/Refund"
  req=
 {
      "requestEnvelope.errorLanguage" => "en_US",
      "payKey" =>@@paykey,
      "currencyCode"=>"USD",
      "receiverList.receiver[0].email"=>"platfo_1255611349_biz@gmail.com",
      "receiverList.receiver[0].amount"=>"1.00"
  }
  data=call(req)
  if(data["responseEnvelope.ack"][0].to_s=="Success")
    puts "Refund Transaction is successfull!" 
  else
    puts "Refund Transaction Failed:"
    puts "error Id:#{data["error(0).errorId"]}"
    puts "error message:#{data["error(0).message"]}"
  end 
end

#Method to make preapproval API call,Preapproval key is returned  on successfull call
def preapproval
   @@endpoints["SERVICE"]="/AdaptivePayments/Preapproval"
    date = Time.new
    startdate=date.strftime("%Y-%m-%d")
    enddate="#{date.year + 1}-#{date.strftime("%m")}-#{date.day}"
  req=
 {
       "requestEnvelope.errorLanguage" => "en_US",
      "clientDetails.ipAddress"=>"127.0.0.1",
      "clientDetails.deviceId" =>"mydevice",
      "clientDetails.applicationId" => "APP-1JE4291016473214C",
      "returnUrl" =>"http://www.hawaii.com",
      "cancelUrl"=>"http://www.return.edu",
      "currencyCode"=>"USD",
      "startingDate" =>startdate,
      "endingDate" => enddate,
      "maxNumberOfPayments" => "10",
      "maxTotalAmountOfAllPayments" => "50.00",
      "requestEnvelope.senderEmail"=>"platfo_1255076101_per@gmail.com"
      
  }
  data=call(req)
  if(data["responseEnvelope.ack"][0].to_s=="Success")
    @@preapprovalKey=data["preapprovalKey"][0]
    puts "Preapproval Transaction is successfull! preapprovalKey is #{data["preapprovalKey"][0]}"
  else
    puts "Preapproval Transaction Failed:"
    puts "error Id:#{data["error(0).errorId"]}"
    puts "error message:#{data["error(0).message"]}"
  end  
end

#Method to make preapprovalDeatils API call, preapprovalKey is given as input is obtained from preapproval method
def preapprovalDeatils
  @@endpoints["SERVICE"]="/AdaptivePayments/PreapprovalDetails"
  req=
 {
       "requestEnvelope.errorLanguage" => "en_US",
       "preapprovalKey" => @@preapprovalKey
  }
  data=call(req)
  if(data["responseEnvelope.ack"][0].to_s=="Success")
    puts "PreapprovalDetails Transaction Successful!" 
  else
    puts "PreapprovalDetails Transaction Failed:"
    puts "error Id:#{data["error(0).errorId"]}"
    puts "error message:#{data["error(0).message"]}"
  end  
end

#Method to make cancelPreapproval API call
def cancelPreapproval
   @@endpoints["SERVICE"]="/AdaptivePayments/CancelPreapproval"
    date = Time.new
    startdate=date.strftime("%Y-%m-%d")
    enddate="#{date.year + 1}-#{date.strftime("%m")}-#{date.day}"
  req=
 {
       "requestEnvelope.errorLanguage" => "en_US",
       "preapprovalKey" => @@preapprovalKey
  }
  data=call(req)
  if(data["responseEnvelope.ack"][0].to_s=="Success")
    puts "CancelPreapproval Transaction Successful!" 
  else
    puts "CancelPreapproval Transaction Failed:"
    puts "error Id:#{data["error(0).errorId"]}"
    puts "error message:#{data["error(0).message"]}"
  end  
end

#Method to make convertCurrency API call
def convertCurrency
  @@endpoints["SERVICE"]="/AdaptivePayments/ConvertCurrency"
  req=
 {
      "requestEnvelope.errorLanguage" => "en_US",
      "baseAmountList.currency(0).amount"=>"1.00",
      "baseAmountList.currency(0).code"=>"GBP",
      "baseAmountList.currency(1).amount"=>"1.00",
      "baseAmountList.currency(1).code"=>"EUR",
      "convertToCurrencyList.currencyCode(0)"=>"USD",
      "convertToCurrencyList.currencyCode(1)"=>"CAD"
  }
  data=call(req)
  if(data["responseEnvelope.ack"][0].to_s=="Success")
    puts "ConvertCurrency Transaction Successful!" 
  else
    puts "ConvertCurrency Transaction Failed:"
    puts "error Id:#{data["error(0).errorId"]}"
    puts "error message:#{data["error(0).message"]}"
  end  
end

puts "Running AdaptivePayment Samples..."
createpay
setPaymentOption
executePay
getPaymentOption
setpay
payDetails
refund
preapproval
preapprovalDeatils
cancelPreapproval
convertCurrency
puts ""
puts "***** Done *****"
print STDIN.getc



