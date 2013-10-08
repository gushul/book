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

end
