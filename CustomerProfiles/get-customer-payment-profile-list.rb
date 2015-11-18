require 'rubygems'
  require 'yaml'
  require 'authorizenet'

  include AuthorizeNet::API

  config = YAML.load_file(File.dirname(__FILE__) + "/../credentials.yml")

  transaction = Transaction.new(config['api_login_id'], config['api_transaction_key'], :gateway => :sandbox)
  
  searchTypeEnum = CustomerPaymentProfileSearchTypeEnum::CardsExpiringInMonth
  sorting = CustomerPaymentProfileSorting.new
  orderByEnum = CustomerPaymentProfileOrderFieldEnum::Id
  sorting.orderBy = orderByEnum
  sorting.orderDescending = false
  
  paging = Paging.new
  paging.limit = 1000
  paging.offset = 1
  
  
  request = GetCustomerPaymentProfileListRequest.new

  request.searchType = searchTypeEnum
  request.month = "2020-12"
  request.sorting = sorting
  request.paging = paging
  
  response = transaction.get_customer_payment_profile_list(request)
  
  if response.messages.resultCode == MessageTypeEnum::Ok
    puts "Successfully got customer payment profile list"
    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    puts "Total Result in Set = #{response.totalNumInResultSet}"
    response.paymentProfiles.paymentProfile.each do |paymentProfile|
      puts "Payment profile id = #{paymentProfile.customerPaymentProfileId}"
      puts "First Name in Billing Address = #{paymentProfile.billTo.firstName}"
      puts "Credit Card Number = #{paymentProfile.payment.creditCard.cardNumber}"
    end
  else
    puts response.messages.messages[0].code
    puts response.messages.messages[0].text
    raise "Failed to get customer payment profile list"
  end
