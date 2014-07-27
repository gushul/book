class Api::RestaurantTagsController < Api::BaseController

	def index
		search_result=RestaurantTag.where("title LIKE ?", "#{params[:tag]}:%")
    render json: search_result
	end	
end