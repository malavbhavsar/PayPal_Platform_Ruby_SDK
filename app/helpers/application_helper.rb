# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
def state_select_for(model)
    states = %w(AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME
                MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN
                TX UT VA VT WA WI WV WY AA AE AP AS FM GU MH MP PR PW VI)
    select(model, :state, states.map { |state| [state, state] }, {:selected => 'TX'})
  end
  
  def biz_state_select_for(model)
    bizstate = %w(AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME
                MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN
                TX UT VA VT WA WI WV WY AA AE AP AS FM GU MH MP PR PW VI)
    select(model, :bizstate, bizstate.map { |bizstate| [bizstate, bizstate] }, {:selected => 'TX'})
  end
  
    def biz_type(model)
    businesstype = %w(ASSOCIATION CORPORATION GENERAL_PARTNERSHIP GOVERNMENT INDIVIDUAL LIMITED_LIABILITY_PARTNERSHIP 
                                LIMITED_LIABILITY_PRIVATE_CORPORATION LIMITED_LIABILITY_PROPRIETORS LIMITED_PARTNERSHIP 
                                LIMITED_PARTNERSHIP_PRIVATE_CORPORATION NONPROFIT OTHER_CORPORATE_BODY PARTNERSHIP 
                                PRIVATE_CORPORATION PRIVATE_PARTNERSHIP PROPRIETORSHIP PROPRIETORSHIP_CRAFTSMAN 
                                PROPRIETARY_COMPANY PUBLIC_COMPANY PUBLIC_CORPORATION PUBLIC_PARTNERSHIP)
    select(model, :businesstype, businesstype.map { |businesstype| [businesstype, businesstype] }, {:selected => 'INDIVIDUAL'})
  end
  
  def account_select_for(model)
    account = %w(PERSONAL PREMIER)
    select(model, :account, account.map { |account| [account, account] }, {:selected => 'PERSONAL'})            
  end
  
  def account_type(model)
    accounttype = %w(CHECKING SAVING BUSINESS_CHECKING BUSINESS_SAVING NORMAL UNKNOWN)
    select(model, :accounttype, accounttype.map { |accounttype| [accounttype, accounttype] }, {:selected => 'CHECKING'})            
  end
  
  def confirmation_type(model)
    confirmationtype = %w(WEB MOBILE)
    select(model, :confirmationtype, confirmationtype.map { |confirmationtype| [confirmationtype, confirmationtype] }, {:selected => 'WEB'})            
  end
  
    def confirmation_type_direct(model)
    confirmationtypedirect = %w(NONE WEB MOBILE)
    select(model, :confirmationtypedirect, confirmationtypedirect.map { |confirmationtypedirect| [confirmationtypedirect, confirmationtypedirect] }, {:selected => 'NONE'})            
  end
  
  def salutation_select_for(model)
    salutation = %w(Dr. Mr. Mrs.)
    select(model, :salutation, salutation.map { |salutation| [salutation, salutation] }, {:selected => 'Dr.'})            
  end
  

  def currency_select_for(model)
    currencies = %w(USD GBP EUR JPY CAD AUD)
    select(model, :currency, currencies.map { |currency| [currency, currency] }, {:selected => 'USD'})            
  end
  
  def year_select_for(model)
    years = %w(2009 2010 2011 2012 2013 2014 2015 2016)
    select(model, :expDateYear, years.map { |expDateYear| [expDateYear, expDateYear] }, {:selected => '2012'})  
  end
  
  def month_select_for(model)
    months = %w(01 02 03 04 05 06 07 08 09 10 11 12)
    select(model, :expDateMonth, months.map { |expDateMonth| [expDateMonth, expDateMonth] }, {:selected => '01'})            
  end
  
end
