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

end
