# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :provider, :uid, :name,
                  :username, :phone, :verify_code, :verified

  validates :phone, :presence => true, :uniqueness => true
  validate  :phone_number_validation, :if => "phone?"  

  before_create :username_setup
  before_create :set_verify_code
  after_create  :send_verification_code_via_email
  after_create  :send_verification_code_via_sms

  has_many :reservations, :dependent => :destroy
  has_many :rewards,      :dependent => :destroy
  has_many :vips,         :dependent => :destroy
  has_many :nicknames,    :dependent => :destroy

  def self.facebook(auth)
    if user = User.find_by_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid 
      user   
    else                                 
      where(auth.slice(:provider, :uid)).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        # TODO: Temp stub
        # user.phone = "0" + auth.uid.slice(0..8)
        user.username = auth.extra.raw_info.name
        # user.password = Devise.friendly_token[0,20]
      end
    end
  end 

  def get_credits
    self.rewards.map(&:points_total).compact.reduce(0, :+)
  end

  def is_vip?(restaurant)
    if Vip.where(user_id: id).where(restaurant_id: restaurant.id).first.present?
      return true
    end
    false
  end

  def send_verification_code_via_sms
    Thread.new do
      require 'net/https'
      require 'open-uri'
      # uri = URI.parse("https://www.siptraffic.com/myaccount/sendsms.php?username=matthewfong&password=psyagbha&from=+6600000000&to=+#{self.phone}&text=#{self.verify_code}")
      uri = URI.parse("https://www.siptraffic.com/myaccount/sendsms.php?username=matthewfong&password=psyagbha&from=+66875928489&to=+#{self.phone.reverse.chop.reverse}&text=Welcome+to+Hungry+Hub.+Your+verification+code+is+#{self.verify_code}.+Please+verify+this+number+on+our+webpage+or+in+our+mobile+application.")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.get(uri.request_uri)
    end
  end

private

  def send_verification_code_via_email
    Thread.new do
      unless ['development'].include?(Rails.env)
        UserMailer.registration_confirmation(self.email, self.verify_code).deliver
      end
    end
  end


  def set_verify_code
     self.verify_code = rand(10 ** 5).to_i
  end

  def phone_number_validation
    unless check_phone_number
      self.errors.add(:phone, "Incorrect phone number format")
    end
  end

  def username_setup
    self.username = self.email.split('@').first if self.username.blank?
  end

  def check_phone_number
    if phone.length == 10 and phone[0,1].to_i == 0
      return true
    end
    false
  end

end  
