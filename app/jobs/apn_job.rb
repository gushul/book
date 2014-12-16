class ApnJob
  @queue = :apn
  #Resque.enqueue(ApnJob, device_id, 'msg')
  def self.perform(device_token, message)
    if (Rails.env.development? || Rails.env.test?)
      apn = Houston::Client.development
      apn.certificate = File.read('config/apple_push_prod.pem')
    else
      apn = Houston::Client
      apn.certificate = File.read('config/apple_push_prod.pem')
    end

    notification = Houston::Notification.new(device: token)
    notification.alert = message

    apn.push(notification)
  end
end