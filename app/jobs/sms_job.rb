class SmsJob
  @queue = :sms

  def self.perform(verify_code, phone)
    require 'net/https'
    require 'open-uri'
    msg = URI.encode("Welcome to Hungry Hub. Your verification code is #{verify_code}. Please verify this number on our webpage (www.hungryhub.com) or in our mobile application (iOS and Android). Hungry Hub")
    uri = URI.parse("http://api.rushsms.com:8080/?username=div-hungryhub&password=hBger932&type=0&delivery=1&mobile=66#{phone}&sender=Hungry+Hub&message=#{msg}")
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.get(uri.request_uri)
  end

 
end