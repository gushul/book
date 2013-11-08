# encoding: utf-8
class ApplicationController < ActionController::Base
  before_filter :set_i18n_locale_from_params
  protect_from_forgery

  rescue_from Exception, :with => :error_render_method

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
