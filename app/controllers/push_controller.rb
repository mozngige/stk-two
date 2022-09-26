class PushController < ApplicationController 
  # this ctrl initiates payment via the payment action
  def index 
    # show all payments
    @payments = Payment.all 
  end 

  def payment 
    # initiate payment by calling payment.new
  end
end