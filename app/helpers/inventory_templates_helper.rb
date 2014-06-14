# encoding: utf-8
module InventoryTemplatesHelper

  def get_intervals
    @intervals = []
      24.times do |h| 
        4.times do |m| 
            if h<10 and m!=0
              @intervals << "0#{h}:#{m*15}" 
            elsif h<10 and m==0
              @intervals << "0#{h}:00" 
            elsif h>=10 and m!=0
              @intervals << "#{h}:#{m*15}" 
            elsif h>=10 and m==0
              @intervals << "#{h}:0#{m*15}" 
            else
              @intervals << "#{h}:#{m*15}" 
            end
        end
      end
    @intervals << "24:00"
  end

  def int_to_hr(int)
    int = "0#{int}" if int < 9
    int
  end

  def int_to_min(int)
    if int == 0 
      int = "0#{int}" 
    else
      int = "#{int*15}"
    end
    int
  end

  def get_color(num)
    color = ''
    case num 
    when 0  
      color = "#d9534f" 
    when 1  
      color = "#428bca" 
    when 2  
      color = "#5cb85c" 
    when 3  
      color = "#f0ad4e" 
    when 4  
      color = "#563d7c" 
    when 5  
      color = "#5bc0de" 
    when 6  
      color = "violet" 
    when 7  
      color = "#999" 
    else  
      color = "black" 
    end  
    return color
  end

end
