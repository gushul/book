# encoding: utf-8
class Api::RestaurantTagsController < Api::BaseController

  skip_before_filter :set_no_cache, :only => [:index]
  # GET /restaurant_tags.json
  def index
    @restaurant_tags = RestaurantTag.all


    @restaurant_tags_json = []
    @restaurant_tags.each do |r|
        r = r.as_json
        %w{owner_id updated_at created_at}.each {|k| r.delete(k)}
        @restaurant_tags_json << r
    end
    expires_in 24.hours, :public => true
    response.headers["Expires"] = 24.hours.from_now.httpdate
    render json: @restaurant_tags_json 
  end

  
end
