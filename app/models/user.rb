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

  has_many :reservations, :dependent => :destroy
  has_many :rewards,      :dependent => :destroy
  has_many :vips,         :dependent => :destroy

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

private

  def send_verification_code_via_email
    unless ['development'].include?(Rails.env)
      UserMailer.registration_confirmation(self.email, self.verify_code).deliver
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