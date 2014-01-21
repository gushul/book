# encoding: utf-8
module ReservationsHelper
  def mtime(time)
    time.strftime('%H:%M')
  end

  def oppsite_bool(bool)
    bool == true ? false : true
  end

  def bool_to_activity(bool)
    bool == true ? "active" : "inactive"
  end

  def vip_or_not(user, name, phone, restaurant)
    if user.present?
      if Vip.where(:user_id => user.id).where(:restaurant_id => restaurant.id).first.present?
        return "VIP"
      end
    else
      if Vip.where(:name => name).where(:phone => phone).where(:restaurant_id => restaurant.id).first.present?
        return "VIP"
      end
    end
    ""
  end

end
