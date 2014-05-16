# encoding: utf-8
module HomeHelper

  def pretty_date_ago(from_time)
    return unless from_time.present?
    str = distance_of_time_in_words(from_time.to_time, Date.today)
    if (str.include? "day") && (str[0].to_i < 7)
      str = "Last #{str[0].to_i.day.ago.strftime("%A")}"   
    else
      str += " ago"  
    end
    str
  end

end
