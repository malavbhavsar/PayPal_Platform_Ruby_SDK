PayPalPlatformRubySDK::Application.routes.draw do

  get "websamples/permission/cancelpermission/begin"
  get "websamples/permission/cancelpermission/cancel"
  get "websamples/permission/cancelpermission/cancel_permissions"
  get "websamples/permission/cancelpermission/cancel_permission_response"

  get "websamples/permission/getpermissions/begin"
  get "websamples/permission/getpermissions/get"
  get "websamples/permission/getpermissions/get_permissions"
  get "websamples/permission/getpermissions/get_permission_response"

  get "websamples/permission/getaccesstoken/begin"
  get "websamples/permission/getaccesstoken/get"
  get "websamples/permission/getaccesstoken/get_token"
  get "websamples/permission/getaccesstoken/get_token_response"

  get "websamples/permission/requestpermissions/begin"
  get "websamples/permission/requestpermissions/add"
  get "websamples/permission/requestpermissions/request_permissions"
  get "websamples/permission/requestpermissions/request_permissions_response"
  
  get "websamples/permission/getbasicpersonaldata/begin"
  get "websamples/permission/getbasicpersonaldata/get"
  get "websamples/permission/getbasicpersonaldata/get_basic_personal_data"
  get "websamples/permission/getbasicpersonaldata/get_basic_personal_data_response"
  
  get "websamples/permission/getadvancedpersonaldata/begin"
  get "websamples/permission/getadvancedpersonaldata/get"
  get "websamples/permission/getadvancedpersonaldata/get_advanced_personal_data"
  get "websamples/permission/getadvancedpersonaldata/get_advanced_personal_data_response"

  get "websamples/permission/calls/index"
  get "websamples/permission/calls/error"
  get "websamples/permission/calls/exception"

  get "websamples/index/index"
  get "websamples/index/menu"

  get "websamples/aa/getverifiedstatus/begin"
  get "websamples/aa/getverifiedstatus/getStatus"
  get "websamples/aa/getverifiedstatus/verified_status"
  get "websamples/aa/getverifiedstatus/details"

  get "websamples/aa/setfundingsourceconfirmed/begin"
  get "websamples/aa/setfundingsourceconfirmed/set"
  get "websamples/aa/setfundingsourceconfirmed/set_funding_source_confirmed"
  get "websamples/aa/setfundingsourceconfirmed/funding_source_details"

  get "websamples/aa/addpaymentcarddirect/begin"
  get "websamples/aa/addpaymentcarddirect/add_card"
  get "websamples/aa/addpaymentcarddirect/add_payment_card_direct"
  get "websamples/aa/addpaymentcarddirect/add_payment_card_details"

  get "websamples/aa/addpaymentcard/begin"
  get "websamples/aa/addpaymentcard/add_card"
  get "websamples/aa/addpaymentcard/add_payment_card"
  get "websamples/aa/addpaymentcard/add_payment_card_details"

  get "websamples/aa/addbankaccountdirect/begin"
  get "websamples/aa/addbankaccountdirect/add_bank"
  get "websamples/aa/addbankaccountdirect/add_bank_account_direct"
  get "websamples/aa/addbankaccountdirect/add_bank_account_details"

  get "websamples/aa/addbankaccount/begin"
  get "websamples/aa/addbankaccount/add_bank"
  get "websamples/aa/addbankaccount/add_bank_account"
  get "websamples/aa/addbankaccount/add_bank_account_details"

  get "websamples/aa/createaccountbusiness/begin"
  get "websamples/aa/createaccountbusiness/create"
  get "websamples/aa/createaccountbusiness/create_account"
  get "websamples/aa/createaccountbusiness/account_details"

  get "websamples/aa/createaccount/begin"
  get "websamples/aa/createaccount/create"
  get "websamples/aa/createaccount/create_account"
  get "websamples/aa/createaccount/account_details"

  get "websamples/aa/calls/index"
  get "websamples/aa/calls/error"
  get "websamples/aa/calls/exception"

  get "websamples/ap/getpaymentoption/begin"
  get "websamples/ap/getpaymentoption/paymentOption"
  get "websamples/ap/getpaymentoption/get_paymentOption"
  get "websamples/ap/getpaymentoption/details"

  get "websamples/ap/executepay/begin"
  get "websamples/ap/executepay/execute"
  get "websamples/ap/executepay/execute_pay"
  get "websamples/ap/executepay/thanks"

  get "websamples/ap/setpaymentoption/begin"
  get "websamples/ap/setpaymentoption/paymentOption"
  get "websamples/ap/setpaymentoption/setpaymetoption"
  get "websamples/ap/setpaymentoption/thanks"

  get "websamples/ap/convertcurrency/begin"
  get "websamples/ap/convertcurrency/setConvertCurrency"
  get "websamples/ap/convertcurrency/convert_currency"
  get "websamples/ap/convertcurrency/details"

  get "websamples/ap/cancelpreapproval/cancelPreapproval"
  get "websamples/ap/cancelpreapproval/cancel"
  get "websamples/ap/cancelpreapproval/details"

  get "websamples/ap/refund/refund"
  get "websamples/ap/refund/do_refund"
  get "websamples/ap/refund/details"

  get "websamples/ap/preapprovaldetails/begin"
  get "websamples/ap/preapprovaldetails/getPreapprovalDetails"
  get "websamples/ap/preapprovaldetails/preapproval_details"
  get "websamples/ap/preapprovaldetails/details"

  get "websamples/ap/setpreapproval/preapproval"
  get "websamples/ap/setpreapproval/set_preapproval"
  get "websamples/ap/setpreapproval/preapproval_details"
  get "websamples/ap/setpreapproval/details"

  get "websamples/ap/paymentdetails/begin"
  get "websamples/ap/paymentdetails/getPaymentDetails"
  get "websamples/ap/paymentdetails/pay_details"
  get "websamples/ap/paymentdetails/details"

  get "websamples/ap/createpay/begin"
  get "websamples/ap/createpay/create"
  get "websamples/ap/createpay/create_pay"
  get "websamples/ap/createpay/details"
  get "websamples/ap/createpay/thanks"

  get "websamples/ap/setpaychained/begin"
  get "websamples/ap/setpaychained/pay"
  get "websamples/ap/setpaychained/set_pay_chained"
  get 'websamples/ap/setpaychained/pay_details'
  get "websamples/ap/setpaychained/thanks"

  get "websamples/ap/calls/index"
  get "websamples/ap/calls/error"
  get "websamples/ap/calls/exception"
 
  get "websamples/ap/setpay/begin"
  get "websamples/ap/setpay/pay"
  get 'websamples/ap/setpay/set_pay'
  get 'websamples/ap/setpay/pay_details'
  get "websamples/ap/setpay/thanks"

  get "websamples/ap/setpayparallel/begin"
  get "websamples/ap/setpayparallel/pay"
  get 'websamples/ap/setpayparallel/set_pay'
  get 'websamples/ap/setpayparallel/pay_details'
  get "websamples/ap/setpayparallel/thanks"

  

  resources :sessions, :only => [:new, :create, :destroy]

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match ':controller(/:action(/:id(.:format)))'
  match ':controller/:action/:id'
  
#match 'setpay' => 'websamples/ap/setpay#set_pay', :as => :setpay
match 'setpay' => 'websamples/ap/setpay#set_pay'
match 'setpayparallel' => 'websamples/ap/setpayparallel#set_pay'
match 'setpaychained' => 'websamples/ap/setpaychained#set_pay_chained'
match 'paydetails' => 'websamples/ap/paymentdetails#pay_details'
match 'preapproval' => 'websamples/ap/setpreapproval#set_preapproval'
match 'preapprovaldetails' => 'websamples/ap/preapprovaldetails#preapproval_details'
match 'refund' => 'websamples/ap/refund#do_refund'
match 'cancelPreapproval' => 'websamples/ap/cancelpreapproval#cancel'
match 'convertCurrency' => 'websamples/ap/convertcurrency#convert_currency'
match 'createpay' => 'websamples/ap/createpay#create_pay'
match 'setPaymentOption' => 'websamples/ap/setpaymentoption#setpaymetoption'
match 'executepay' => 'websamples/ap/executepay#execute_pay'
match 'getPaymentOption' => 'websamples/ap/getpaymentoption#get_paymentOption'
match 'createaccount' => 'websamples/aa/createaccount#create_account'
match 'createaccountBusiness' => 'websamples/aa/createaccountbusiness#create_account'
match 'addbank' => 'websamples/aa/addbankaccount#add_bank_account'
match 'addbankDirect' => 'websamples/aa/addbankaccountdirect#add_bank_account_direct'
match 'addcard' => 'websamples/aa/addpaymentcard#add_payment_card'
match 'addcardDirect' => 'websamples/aa/addpaymentcarddirect#add_payment_card_direct'
match 'fundingSource' => 'websamples/aa/setfundingsourceconfirmed#set_funding_source_confirmed'
match 'verifiedStatus' => 'websamples/aa/getverifiedstatus#verified_status'
match 'requestpermissions' => 'websamples/permission/requestpermissions#request_permissions'
match 'getadvancedpersonaldata' => 'websamples/permission/getadvancedpersonaldata#get_advanced_personal_data'
match 'getbasicpersonaldata' => 'websamples/permission/getbasicpersonaldata#get_basic_personal_data'

match 'accesstoken' => 'websamples/permission/getaccesstoken#get_token'
match 'getpermissions' => 'websamples/permission/getpermissions#get_permissions'
match 'cancelpermissions' => 'websamples/permission/cancelpermission#cancel_permissions'
  #match "/setpay(.:format)" => "websamples/ap/setpay#set_pay", :as => :setpay  
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
 #root :to => "wppro#index"
 #root :to => "websamples/ap/calls#index2"
   root :to => "websamples/index#index"
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
