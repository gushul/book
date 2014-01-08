# encoding: utf-8
module ApplicationHelper

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def lang_link(link_text, link_path)
    class_name = params["locale"] == link_text.downcase ? 'red' : ''
    link_to link_text, link_path , class: "rblack #{class_name}"
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
