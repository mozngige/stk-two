require "httparty" 
require "json" 
require "base64"

module MpesaStk 
  class AccessToken 
    # define a singleton class 
    class << self 
      # methods defined in this class will be class methods, since they are defined on the class object 
      def call(key=nil, secret=nil)  
        # new is a constructor method 
        new(key, secret).get_access_token  
      end
    end

    # new = constructor 
    def initialize(key=nil, secret=nil)
      # set env keys 
      @key = key.nil? ? ENV['key'] : key # set key if it is nil else return the existing key 
      @secret = secret.nil? ? ENV['secret'] : secret
    end

    def get_access_token 
      # hit token_generator endpoint
      response = HTTParty.get(url, headers: headers) 
      JSON.parse(response.body).fetch['access_token'] # returns an access_token 
    end

    private
    def url 
      "#{ENV['base_url']}#{ENV['token_generator_url']}"
    end

    def headers 
      encode = encode_credentials 
      {
        'Authorization' => "Basic#{encode}", 
      }
    end

    def encode_credentials 
      @encode = Base64.encode64("#{ENV['key']}:#{ENV['secret']}").split("\n").join 
    end
  end
end