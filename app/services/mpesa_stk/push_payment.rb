require_relative './access_token' 
# with this line, we require all modules present in acces_token 

module MpesaStk 
  class PushPayment 
    # define a singleton class to initialize payment 
    class << self 
      def call(amount, phone_number) 
        new(amount, phone_number).push_payment 
      end
    end

    def initialize(amount, phone_number) 
      @amount = amount
      @phone_number = phone_number
      # get token 
      @token = MpesaStk::AccessToken.call()
    end

    attr_reader :amount, :phone_number, :token  

    def push_payment 
      # make a post request 
      response = HTTParty.post(url, headers, body) 
      JSON.parse(response.body)
    end

    private 
    def url 
      "#{ENV['base_url']}#{ENV['process_request_url']}"
    end

    def headers 
      {
        'Authorization' => "Bearer#{token}",
        'Content-type' => 'application/json'
      }
    end

    def body 
      {
        BusinessShortCode: "#{ENV['business_short_code']}",
        Password: generate_password,
        Timestamp: timestamp,
        TransactionType: 'CustomerPayBillOnline', # for paybill 
        Amount: amount.to_s,
        PartyA: phone_number.to_s,
        PartyB: "#{ENV['business_short_code']}",
        PhoneNumber: phone_number.to_s,
        CallBackURL: "#{ENV['callback_url']}",
        AccountReference: generate_bill_reference_number(5),
        TransactionDesc: generate_bill_reference_number(5)
      }.to_json
    end

    def generate_password 
      key = "#{ENV['business_short_code']}#{ENV['business_passkey']}#{timestamp}"
      Base64.encode(key).split("\n").join 
    end

    def generate_bill_reference_number 
      charset = Array('A'..'Z') + Array('a'..'z')
      Array.new(number) { charset.sample }.join
    end
  end 
end
