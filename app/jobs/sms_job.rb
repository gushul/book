class SmsJob
  @queue = :sms

#  def self.perform(verify_code, phone)
  def self.perform(msg, phone)
    require 'net/https'
    require 'open-uri'
#    msg = URI.encode("Welcome to Hungry Hub. Your verification code is #{verify_code}. Please verify this number on our webpage (www.hungryhub.com) or in our mobile application (iOS and Android). Hungry Hub")
#    uri = URI.parse("http://api.rushsms.com:8080/?username=div-hungryhub&password=hBger932&type=0&delivery=1&mobile=66#{phone}&sender=Hungry+Hub&message=#{msg}")
    uri = URI.parse("http://www.thaibulksms.com/sms_api.php?username=hungryhub&password=702287&msisdn=0#{phone}&message=#{URI.encode(msg)}&sender=HungryHub")
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.get(uri.request_uri)
  end

 
end