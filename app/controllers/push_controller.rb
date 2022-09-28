class PushController < ApplicationController 
  # this ctrl initiates payment via the payment action
  def index 
    # show all payments
    @payments = Payment.all 
  end 

  def payment 
    # initiate payment by calling payment.new
    # check params 
    if params.present? 
      phone = PhonyRails.normalize_number(params[:phone_number], country_code: 'KE').gsub(/\W/, '')
      # new payment 
      # @amount = params[:amount]
      # @phone_number = phone 
      
      payment = Payment.new(amount: params[:amount], phone_number: phone )
      
      
      # binding.irb
      if payment.save 
        redirect_to root_path, :flash => { success: "payment successful"}
      else 
        redirect_to root_path, :flash => { alert: "unknown error occurred"} 
      end

    end

    # rescue exception 
  rescue Exception => e 
    p e.message 
  end
  
  # callback fnc 
  def callback 
    merchantRequestId = params[:Body][:stkCallback][:MerchantRequestID]
    checkoutRequestId = params[:Body][:stkCallback][:CheckoutRequestID]

    amount, phonenumber, mpesareceiptnumber, transactiondate = nil 
    # setting the above values will validate a transaction 

    # scope callbackmetadata, to retrieve above data 
    if params[:Body][:stkCallback][:CallbackMetadata].present? 
      # iterate thru each item 
      params[:Body][:stkCallback][:CallbackMetadata][:Item].each do |item| 
        # for each item 
        # switch case 
        case item[:Name].downcase 
        when 'amount' 
          amount = item[:Value]
        when 'mpesareceiptnumber'
          mpesareceiptnumber = item[:Value] 
        when 'transactiondate'
          transactiondate = item[:Value] 
        when 'phonenumber' 
          phonenumber = item[:Value]
        end
      end

      # retrieve a payment, if payment has been successfully made 
      pay = Payment.find_by(amount: amount, phonenumber: phonenumber, merchantRequestId: MerchantRequestID, checkoutRequestId: CheckoutRequestID ) # ensure the check matches all these params 
      # alter state of payment 
      pay.state = true 
      pay.code = mpesareceiptnumber
      pay.save

    else 
      # if payment was unsuccessful 
      pay = Payment.find_by(checkoutRequestId: CheckoutRequestID, merchantRequestId: MerchantRequestID) 
      result_desc = params[:Body][:stkCallback][:ResultDesc]
      pay.code = result_desc
      pay.save
    end
    # save this transaction 
    Transaction.create({ callback: params })
  end 
end