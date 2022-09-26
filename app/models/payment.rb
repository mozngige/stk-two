class Payment < ApplicationRecord 
  # this class processes payments
  after_create :push_stk 
  # after_create is called after saving new object to db 
  # after_create is wrapped in around save  

  def push_stk 
    # this method invokes code written in push_payment.rb as appropriate 
    # after a payment is created, call this method on it 
    begin 
      response = MpesaStk::PushPayment.call(amount, phone_number)
      p response 
      # set these value for a specific transation
      self.MerchantRequestID = response[:MerchantRequestID]
      self.CheckoutRequestID = response[:CheckoutRequestID]

      self.response = response 
      
      self.save 

    rescue => ex 
      p ex.message 

      self.response = ex.message 
      self.save 
    end
  end
end