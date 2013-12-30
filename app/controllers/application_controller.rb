# encoding: utf-8
class ApplicationController < ActionController::Base
  before_filter :set_i18n_locale_from_params
  protect_from_forgery
  
  def after_sign_in_path_for(resource)
    return owner_dashboards_path if owner_signed_in?
    return root_path if user_signed_in?
  end

  # rescue_from Exception, :with => :error_render_method

protected

  def error_render_method
    respond_to do |type|
      # type.html { render :template => "404", :status => 404 }
      type.html { render file: "public/404", formats: :html, status: 404 }
      type.all  { render :nothing => true, :status => 404 }
    end
    true
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = 
          "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  # Предоставляет хэш из URL-дополнений, которые считаются 
  # предоставленными, если они на самом деле не предоставлены    
  def default_url_options
    { locale: I18n.locale }
  end

end

# 
# curl -X POST -H "Content-Type: application/json" -d '{"user":{"password":"secret12", "email":"user2@mail.com"}, "reservation":{"restaurant_id":1, "party_size":5, "start_time":"2013-11-08 03:00:56", "active":"false", "date":"2013-11-08 03:00:56", "end_time":"2013-11-08 03:00:56"}}' http://localhost:3000/api/reservatio11ns/create
