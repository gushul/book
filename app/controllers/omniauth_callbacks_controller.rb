# encoding: utf-8
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
 
  def facebook
    user = User.facebook(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in through Facebook!"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      flash.notice = "You are almost Done! Please provide a phone number and password to finish setting up your account"
      redirect_to new_user_registration_url
    end
  end

end
     