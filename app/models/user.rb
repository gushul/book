# encoding: utf-8
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, #:token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :async,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :provider, :uid, :name,
                  :username, :phone, :verify_code, :verified, :r_code

  validates :phone, :presence => true, :uniqueness => true
  validate  :phone_number_validation, :if => "phone?"  

  before_create :username_setup
  before_create :set_verify_code
  after_create  :send_verification_code_via_email
  after_create  :send_verification_code_via_sms

  has_many :reservations, :dependent => :destroy
  has_many :rewards,      :dependent => :destroy
  has_many :favs,      :dependent => :destroy
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
#    self.rewards.map(&:points_total).compact.reduce(0, :+)
    rewards_points = 0
    self.rewards.each do |r|
	    rewards_points = rewards_points + r.points_total.to_i - r.points_pending.to_i
    end
    return rewards_points
  end

  def is_vip?(restaurant)
    if Vip.where(user_id: id).where(restaurant_id: restaurant.id).first.present?
      return true
    end
    false
  end

  def send_verification_code_via_sms
#    Resque.enqueue(SmsJob, self.verify_code.to_s.rjust(5, '0'), self.phone.reverse.chop.reverse)
#    Resque.enqueue(SmsJob, "Welcome to Hungry Hub. Your verification code is #{self.verify_code.to_s.rjust(5, '0')}. Please verify this number on Hungry Hub website or mobile app. -Hungry Hub", self.phone.reverse.chop.reverse)
    Resque.enqueue(SmsJob, "Welcome to Hungry Hub. You are just 3 clicks away from making your first table booking. Enjoy Hungry Hubbing. :)", self.phone.reverse.chop.reverse)
    self.verified = true
    self.save
    self.create_my_r_code
  end
  
  def create_my_r_code
    my_r_code = "#{self.username.gsub(/[^a-z]/i, '').first(5).upcase}#{rand(0..9)}"
    while !User.find_by_my_r_code("my_r_code").nil? do
      my_r_code = "#{self.username.gsub(/[^a-z]/i, '').first(5).upcase}#{rand(0..9)}"
    end
    self.my_r_code = my_r_code
    self.save
  end
  
  def self.create_all_my_r_codes
    User.all.each do |u|
      u.create_my_r_code
    end
  end



private

  def send_verification_code_via_email
#    Thread.new do
#      unless ['development'].include?(Rails.env)
        UserMailer.registration_confirmation(self.email, self.verify_code, self.username).deliver
#      end
#    end
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
