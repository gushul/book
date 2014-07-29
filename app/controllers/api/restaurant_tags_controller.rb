class Api::RestaurantTagsController < Api::BaseController

	def index
		search_result=RestaurantTag.where("title LIKE ?", "#{params[:tag]}:%")
		search_result.each do |restaurant_tag|
			restaurant_tag[:tag_value]=restaurant_tag.title[restaurant_tag.title.index(':')+1..restaurant_tag.title.length]
		end
    render json: search_result
	end	
end